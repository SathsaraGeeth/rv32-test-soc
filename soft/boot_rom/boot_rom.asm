
boot_rom.elf:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <_start>:
   0:	00011117          	auipc	sp,0x11
   4:	00010113          	mv	sp,sp
   8:	00001297          	auipc	t0,0x1
   c:	ff828293          	addi	t0,t0,-8 # 1000 <__bss_end>
  10:	00001317          	auipc	t1,0x1
  14:	ff030313          	addi	t1,t1,-16 # 1000 <__bss_end>
  18:	0062d863          	bge	t0,t1,28 <_start+0x28>
  1c:	0002a023          	sw	zero,0(t0)
  20:	00428293          	addi	t0,t0,4
  24:	ff5ff06f          	j	18 <_start+0x18>
  28:	084000ef          	jal	ac <main>
  2c:	0000006f          	j	2c <_start+0x2c>

00000030 <uart_init>:
  30:	36400793          	li	a5,868
  34:	00f52c23          	sw	a5,24(a0)
  38:	00100793          	li	a5,1
  3c:	00f52423          	sw	a5,8(a0)
  40:	00f52623          	sw	a5,12(a0)
  44:	00008067          	ret

00000048 <uart_tx_char>:
  48:	00052783          	lw	a5,0(a0)
  4c:	fe07cee3          	bltz	a5,48 <uart_tx_char>
  50:	00b52023          	sw	a1,0(a0)
  54:	00008067          	ret

00000058 <uart_rx_char>:
  58:	00452783          	lw	a5,4(a0)
  5c:	fe07cee3          	bltz	a5,58 <uart_rx_char>
  60:	0ff7f513          	zext.b	a0,a5
  64:	00008067          	ret

00000068 <uart_print_str>:
  68:	0005c783          	lbu	a5,0(a1)
  6c:	02078663          	beqz	a5,98 <uart_print_str+0x30>
  70:	00a00693          	li	a3,10
  74:	00d00613          	li	a2,13
  78:	02d78263          	beq	a5,a3,9c <uart_print_str+0x34>
  7c:	0005c703          	lbu	a4,0(a1)
  80:	00158593          	addi	a1,a1,1
  84:	00052783          	lw	a5,0(a0)
  88:	fe07cee3          	bltz	a5,84 <uart_print_str+0x1c>
  8c:	00e52023          	sw	a4,0(a0)
  90:	0005c783          	lbu	a5,0(a1)
  94:	fe0792e3          	bnez	a5,78 <uart_print_str+0x10>
  98:	00008067          	ret
  9c:	00052783          	lw	a5,0(a0)
  a0:	fe07cee3          	bltz	a5,9c <uart_print_str+0x34>
  a4:	00c52023          	sw	a2,0(a0)
  a8:	fd5ff06f          	j	7c <uart_print_str+0x14>

000000ac <main>:
  ac:	fe010113          	addi	sp,sp,-32 # 10fe0 <__bss_end+0xffe0>
  b0:	20001537          	lui	a0,0x20001
  b4:	00112e23          	sw	ra,28(sp)
  b8:	00812c23          	sw	s0,24(sp)
  bc:	00912a23          	sw	s1,20(sp)
  c0:	01212823          	sw	s2,16(sp)
  c4:	01312623          	sw	s3,12(sp)
  c8:	01412423          	sw	s4,8(sp)
  cc:	f65ff0ef          	jal	30 <uart_init>
  d0:	05200593          	li	a1,82
  d4:	20001537          	lui	a0,0x20001
  d8:	f71ff0ef          	jal	48 <uart_tx_char>
  dc:	04800413          	li	s0,72
  e0:	0080006f          	j	e8 <main+0x3c>
  e4:	f65ff0ef          	jal	48 <uart_tx_char>
  e8:	20001537          	lui	a0,0x20001
  ec:	f6dff0ef          	jal	58 <uart_rx_char>
  f0:	00050793          	mv	a5,a0
  f4:	04500593          	li	a1,69
  f8:	20001537          	lui	a0,0x20001
  fc:	fe8794e3          	bne	a5,s0,e4 <main+0x38>
 100:	04100593          	li	a1,65
 104:	000019b7          	lui	s3,0x1
 108:	444f5a37          	lui	s4,0x444f5
 10c:	f3dff0ef          	jal	48 <uart_tx_char>
 110:	00098993          	mv	s3,s3
 114:	e45a0a13          	addi	s4,s4,-443 # 444f4e45 <_estack+0x444e3e45>
 118:	02000913          	li	s2,32
 11c:	00000413          	li	s0,0
 120:	00000493          	li	s1,0
 124:	20001537          	lui	a0,0x20001
 128:	f31ff0ef          	jal	58 <uart_rx_char>
 12c:	00851533          	sll	a0,a0,s0
 130:	00840413          	addi	s0,s0,8
 134:	00a4e4b3          	or	s1,s1,a0
 138:	ff2416e3          	bne	s0,s2,124 <main+0x78>
 13c:	01448e63          	beq	s1,s4,158 <main+0xac>
 140:	04100593          	li	a1,65
 144:	20001537          	lui	a0,0x20001
 148:	00498993          	addi	s3,s3,4 # 1004 <__bss_end+0x4>
 14c:	fe99ae23          	sw	s1,-4(s3)
 150:	ef9ff0ef          	jal	48 <uart_tx_char>
 154:	fc9ff06f          	j	11c <main+0x70>
 158:	04400593          	li	a1,68
 15c:	20001537          	lui	a0,0x20001
 160:	ee9ff0ef          	jal	48 <uart_tx_char>
 164:	17800593          	li	a1,376
 168:	20001537          	lui	a0,0x20001
 16c:	efdff0ef          	jal	68 <uart_print_str>
 170:	691000ef          	jal	1000 <__bss_end>
 174:	0000006f          	j	174 <main+0xc8>
 178:	6946                	.insn	2, 0x6946
 17a:	6d72                	.insn	2, 0x6d72
 17c:	65726177          	.insn	4, 0x65726177
 180:	6920                	.insn	2, 0x6920
 182:	6f6c2073          	.insn	4, 0x6f6c2073
 186:	6461                	.insn	2, 0x6461
 188:	6465                	.insn	2, 0x6465
 18a:	2e20                	.insn	2, 0x2e20
 18c:	2e2e                	.insn	2, 0x2e2e
 18e:	0a0d                	.insn	2, 0x0a0d
	...
