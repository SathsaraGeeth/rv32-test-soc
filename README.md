# rv32I-test-soc

A simple RV32I-based SoC for **hardware testing, peripheral validation, and basic SoC experiments**.

---

## Features
- RV32I single-cycle core (from PicoRV32)
- Scratchpad Memory (SPM)
- Boot ROM
- GPIO
- UART interface for serial communication
- Boot ROM + loader to upload firmware/apps over UART

---

## Project Structure

### 1. RTL (`/rtl`)
- `core.sv`                 : RV32I core implementation
- `soc.sv`                  : Top-level SoC module
- `spm.sv`                  : Scratchpad memory
- `uart.sv`                 : UART implementation
- `uart_mmio.sv`            : UART memory-mapped interface
- `gpio_bank.sv`            : GPIO peripheral
- `rom.sv`                  : Boot ROM
- `bus_interconnect.sv`     : SoC interconnect
- `dram_adp.sv`             : DRAM adapter

### 2. FPGA (`/fpga`)
- `top.v`                   : FPGA top wrapper
- `pynq_wrapper.sv`         : PYNQ Z2 specific wrapper
- `pynqz2_constraints.xdc`  : Constraints for target FPGA

### 3. Soft (`/soft`)
- **App (`/soft/app`)**
  - Example firmware (`app.asm`, `.c`, `.elf`, `.bin`, `.hex`)
  - Drivers (`/src/drivers`) for GPIO & UART
  - Makefile & linker scripts for compilation
- **Boot ROM (`/soft/boot_rom`)**
  - Bootloader source and binaries
  - Load firmware via `load.py`
- **UART Loader (`/soft/uart_loader`)**
  - Python script to flash applications

### 4. Verification (`/verf`)
- `tb_core.py`      : Testbench for core (based on cocotb)
- `tb_soc.py`       : Testbench for top-level SoC (based on cocotb)

---

## Usage
1. Compile and load firmware from `/soft/app` using `load.py`.
2. Assign GPIO/UART pins in `/fpga` for your target FPGA/vendor.
3. Simulate using the provided testbenches (`/verf`) or synthesize on FPGA.

---

## License
Use freely for **educational and experimental purposes**.
