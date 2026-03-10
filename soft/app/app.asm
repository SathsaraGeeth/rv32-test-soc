
app.elf:     file format elf32-littleriscv


Disassembly of section .text:

00001000 <_start>:
    1000:	00010117          	auipc	sp,0x10
    1004:	00010113          	mv	sp,sp
    1008:	00000297          	auipc	t0,0x0
    100c:	05028293          	addi	t0,t0,80 # 1058 <__bss_end>
    1010:	00000317          	auipc	t1,0x0
    1014:	04830313          	addi	t1,t1,72 # 1058 <__bss_end>
    1018:	0062d863          	bge	t0,t1,1028 <_start+0x28>
    101c:	0002a023          	sw	zero,0(t0)
    1020:	00428293          	addi	t0,t0,4
    1024:	ff5ff06f          	j	1018 <_start+0x18>
    1028:	018000ef          	jal	1040 <main>
    102c:	0000006f          	j	102c <_start+0x2c>

00001030 <uart_tx_char>:
    1030:	00052783          	lw	a5,0(a0)
    1034:	fe07cee3          	bltz	a5,1030 <uart_tx_char>
    1038:	00b52023          	sw	a1,0(a0)
    103c:	00008067          	ret

00001040 <main>:
    1040:	ff010113          	addi	sp,sp,-16 # 10ff0 <__bss_end+0xff98>
    1044:	00112623          	sw	ra,12(sp)
    1048:	06700593          	li	a1,103
    104c:	20001537          	lui	a0,0x20001
    1050:	fe1ff0ef          	jal	1030 <uart_tx_char>
    1054:	ff5ff06f          	j	1048 <main+0x8>
