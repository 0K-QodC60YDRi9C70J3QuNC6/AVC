	.file	"asm_examples.cpp"
	.option pic
	.attribute arch, "rv64i2p1_m2p0_a2p1_f2p2_d2p2_c2p0_zicsr2p0_zifencei2p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.align	1
	.globl	f_and
	.type	f_and, @function
f_and:
.LFB2:
	.cfi_startproc
	andi	a0,a0,0xff
	ret
	.cfi_endproc
.LFE2:
	.size	f_and, .-f_and
	.align	1
	.globl	f_or
	.type	f_or, @function
f_or:
.LFB3:
	.cfi_startproc
	ori	a0,a0,1
	ret
	.cfi_endproc
.LFE3:
	.size	f_or, .-f_or
	.align	1
	.globl	f_shl
	.type	f_shl, @function
f_shl:
.LFB4:
	.cfi_startproc
	slliw	a0,a0,3
	ret
	.cfi_endproc
.LFE4:
	.size	f_shl, .-f_shl
	.align	1
	.globl	f_sar
	.type	f_sar, @function
f_sar:
.LFB5:
	.cfi_startproc
	srai	a0,a0,3
	ret
	.cfi_endproc
.LFE5:
	.size	f_sar, .-f_sar
	.align	1
	.globl	f_xor
	.type	f_xor, @function
f_xor:
.LFB6:
	.cfi_startproc
	srliw	a5,a0,16
	xor	a0,a5,a0
	sext.w	a0,a0
	ret
	.cfi_endproc
.LFE6:
	.size	f_xor, .-f_xor
	.align	1
	.globl	d7
	.type	d7, @function
d7:
.LFB7:
	.cfi_startproc
	li	a5,7
	divw	a0,a0,a5
	ret
	.cfi_endproc
.LFE7:
	.size	d7, .-d7
	.align	1
	.globl	m7
	.type	m7, @function
m7:
.LFB8:
	.cfi_startproc
	li	a5,7
	remw	a0,a0,a5
	ret
	.cfi_endproc
.LFE8:
	.size	m7, .-m7
	.align	1
	.globl	divide
	.type	divide, @function
divide:
.LFB9:
	.cfi_startproc
	divw	a0,a0,a1
	ret
	.cfi_endproc
.LFE9:
	.size	divide, .-divide
	.align	1
	.globl	rotate_xor
	.type	rotate_xor, @function
rotate_xor:
.LFB10:
	.cfi_startproc
	lw	a5,0(a1)
	lw	a4,0(a0)
	xor	a4,a4,a5
	sw	a4,0(a0)
	lw	a5,0(a1)
	xor	a5,a5,a4
	sw	a5,0(a1)
	lw	a4,0(a0)
	xor	a5,a4,a5
	sw	a5,0(a0)
	lw	a5,0(a2)
	lw	a4,0(a1)
	xor	a4,a4,a5
	sw	a4,0(a1)
	lw	a5,0(a2)
	xor	a5,a5,a4
	sw	a5,0(a2)
	lw	a4,0(a1)
	xor	a5,a4,a5
	sw	a5,0(a1)
	ret
	.cfi_endproc
.LFE10:
	.size	rotate_xor, .-rotate_xor
	.align	1
	.globl	rotate_arithmetic
	.type	rotate_arithmetic, @function
rotate_arithmetic:
.LFB11:
	.cfi_startproc
	lw	a5,0(a0)
	lw	a4,0(a1)
	addw	a4,a4,a5
	sw	a4,0(a0)
	lw	a3,0(a1)
	subw	a5,a4,a3
	sw	a5,0(a1)
	lw	a5,0(a0)
	addw	a5,a5,a3
	subw	a5,a5,a4
	sw	a5,0(a0)
	lw	a5,0(a1)
	lw	a4,0(a2)
	addw	a4,a4,a5
	sw	a4,0(a1)
	lw	a3,0(a2)
	subw	a5,a4,a3
	sw	a5,0(a2)
	lw	a5,0(a1)
	addw	a5,a5,a3
	subw	a5,a5,a4
	sw	a5,0(a1)
	ret
	.cfi_endproc
.LFE11:
	.size	rotate_arithmetic, .-rotate_arithmetic
	.align	1
	.globl	rotate_temporary
	.type	rotate_temporary, @function
rotate_temporary:
.LFB12:
	.cfi_startproc
	lw	a4,0(a1)
	lw	a5,0(a0)
	sw	a4,0(a0)
	lw	a4,0(a2)
	sw	a4,0(a1)
	sw	a5,0(a2)
	ret
	.cfi_endproc
.LFE12:
	.size	rotate_temporary, .-rotate_temporary
	.ident	"GCC: (Debian 12.2.0-13) 12.2.0"
	.section	.note.GNU-stack,"",@progbits
