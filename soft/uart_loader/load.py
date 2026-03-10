import serial
import sys
import time
import struct
import os

PORT = "/dev/serial0"
BAUD = 115200

BOOT_READY = b'R'
HANDSHAKE  = b'H'
ACK        = b'A'
ERR        = b'E'
DONE_ACK   = b'D'       # single byte ACK for DONE
DONE_WORD  = b'ENOD'    # 4-byte DONE marker

def log(msg):
    print(f"[HOST] {msg}")

def pad_firmware(data):
    if len(data) % 4 != 0:
        data += b'\x00' * (4 - len(data) % 4)
    return data

def send_firmware(ser, filename):
    firmware = open(filename, "rb").read()
    firmware = pad_firmware(firmware)

    words = [firmware[i:i+4] for i in range(0, len(firmware), 4)]
    total_words = len(words)

    log(f"Sending {filename}: {len(firmware)} bytes ({total_words} words)")

    word_index = 0
    state = "SEND_WORD"

    while state != "DONE":
        if state == "SEND_WORD":
            if word_index < total_words:
                word = words[word_index]
                ser.write(word)
                state = "WAIT_WORD_ACK"
            else:
                log("All words sent → sending DONE marker")
                ser.write(DONE_WORD)
                state = "WAIT_DONE_ACK"
            continue

        b = ser.read(1)
        if not b:
            continue

        if state == "WAIT_WORD_ACK":
            if b == ACK:
                word_index += 1
                state = "SEND_WORD"
            elif b == ERR:
                log(f"WORD {word_index} error → retransmit")
                state = "SEND_WORD"

        elif state == "WAIT_DONE_ACK":
            if b == DONE_ACK:
                log(f"{filename} upload complete")
                state = "DONE"
            elif b == ERR:
                log("DONE error → resend DONE")
                ser.write(DONE_WORD)

def main():
    if len(sys.argv) < 2:
        print("Usage: python3 loader.py file1.bin file2.bin ...")
        sys.exit(1)

    files = sys.argv[1:]

    ser = serial.Serial(PORT, BAUD, timeout=0.05)
    time.sleep(1)

    log("Waiting for BOOT_ROM ready...")
    while True:
        b = ser.read(1)
        if not b:
            continue
        if b == BOOT_READY:
            log("ROM ready detected")
            break

    print("Files to upload:")
    for i, f in enumerate(files):
        print(f"{i+1}: {f}")

    selected = input("Enter indices of files to upload (comma separated): ")
    indices = [int(x.strip())-1 for x in selected.split(",") if x.strip().isdigit()]

    ser.write(HANDSHAKE)
    while True:
        b = ser.read(1)
        if not b:
            continue
        if b == ACK:
            log("Handshake acknowledged → start sending files")
            break
        elif b == ERR:
            log("Handshake error → resend HANDSHAKE")
            ser.write(HANDSHAKE)

    for idx in indices:
        if 0 <= idx < len(files):
            send_firmware(ser, files[idx])

    ser.close()
    log("All selected files uploaded. Serial port closed.")

if __name__ == "__main__":
    main()
