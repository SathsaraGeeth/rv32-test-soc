    .section .init
    .globl _start
_start:
    /* Set stack pointer to top of SPM */
    la sp, _estack

    /* Zero the BSS section in SPM */
    la t0, __bss_start
    la t1, __bss_end
1:  
    bge t0, t1, 2f       /* if t0 >= t1, done */
    sw  zero, 0(t0)      /* zero memory */
    addi t0, t0, 4
    j 1b

2:
    /* Call main boot ROM routine */
    call main

3:
    j 3b                 /* infinite loop if main returns */
    