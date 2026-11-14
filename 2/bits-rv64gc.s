	.file	"bits.cpp"
	.option pic
	.attribute arch, "rv64i2p1_m2p0_a2p1_f2p2_d2p2_c2p0_zicsr2p0_zifencei2p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.align	1
	.globl	bswap32
	.type	bswap32, @function
bswap32:
.LFB240:
	.cfi_startproc
	srliw	a3,a0,24
	slliw	a5,a0,24
	slliw	a4,a0,8
	or	a5,a5,a3
	li	a3,16711680
	and	a4,a4,a3
	or	a5,a5,a4
	li	a4,65536
	addi	a4,a4,-256
	srliw	a0,a0,8
	and	a0,a0,a4
	or	a0,a5,a0
	sext.w	a0,a0
	ret
	.cfi_endproc
.LFE240:
	.size	bswap32, .-bswap32
	.align	1
	.globl	is_pow2
	.type	is_pow2, @function
is_pow2:
.LFB241:
	.cfi_startproc
	addi	a5,a0,-1
	and	a5,a5,a0
	seqz	a5,a5
	snez	a0,a0
	and	a0,a0,a5
	ret
	.cfi_endproc
.LFE241:
	.size	is_pow2, .-is_pow2
	.align	1
	.globl	parity32
	.type	parity32, @function
parity32:
.LFB242:
	.cfi_startproc
	srliw	a5,a0,16
	xor	a0,a5,a0
	srliw	a5,a0,8
	xor	a0,a0,a5
	srliw	a5,a0,4
	xor	a0,a0,a5
	srliw	a5,a0,2
	xor	a0,a0,a5
	srliw	a5,a0,1
	xor	a0,a0,a5
	andi	a0,a0,1
	ret
	.cfi_endproc
.LFE242:
	.size	parity32, .-parity32
	.align	1
	.globl	popcount32
	.type	popcount32, @function
popcount32:
.LFB243:
	.cfi_startproc
	li	a5,1431654400
	srliw	a4,a0,1
	addi	a5,a5,1365
	and	a5,a5,a4
	subw	a0,a0,a5
	li	a4,858992640
	srliw	a3,a0,2
	addi	a4,a4,819
	and	a5,a4,a0
	and	a4,a4,a3
	addw	a5,a5,a4
	srliw	a4,a5,4
	addw	a4,a4,a5
	li	a5,252645376
	addi	a5,a5,-241
	and	a5,a5,a4
	slliw	a0,a5,8
	addw	a0,a0,a5
	slliw	a5,a0,16
	addw	a0,a0,a5
	srliw	a0,a0,24
	ret
	.cfi_endproc
.LFE243:
	.size	popcount32, .-popcount32
	.align	1
	.globl	ctz32
	.type	ctz32, @function
ctz32:
.LFB244:
	.cfi_startproc
	negw	a4,a0
	li	a5,125612032
	and	a4,a0,a4
	addiw	a5,a5,1329
	mulw	a4,a4,a5
	lla	a3,.LANCHOR0
	seqz	a5,a0
	negw	a5,a5
	srliw	a4,a4,27
	add	a4,a3,a4
	lbu	a0,0(a4)
	xori	a4,a0,32
	and	a5,a5,a4
	xor	a0,a0,a5
	sext.w	a0,a0
	ret
	.cfi_endproc
.LFE244:
	.size	ctz32, .-ctz32
	.align	1
	.globl	clz32
	.type	clz32, @function
clz32:
.LFB245:
	.cfi_startproc
	srliw	a6,a0,16
	seqz	a6,a6
	slliw	a6,a6,4
	sllw	a4,a0,a6
	srliw	a1,a4,24
	seqz	a1,a1
	slliw	a1,a1,3
	sllw	a4,a4,a1
	srliw	a2,a4,28
	seqz	a2,a2
	slliw	a2,a2,2
	sllw	a4,a4,a2
	srliw	a3,a4,30
	seqz	a5,a0
	seqz	a3,a3
	slliw	a3,a3,1
	addw	a5,a5,a6
	addw	a5,a5,a1
	sllw	a0,a4,a3
	addw	a5,a5,a2
	not	a0,a0
	addw	a5,a5,a3
	srliw	a0,a0,31
	addw	a0,a5,a0
	ret
	.cfi_endproc
.LFE245:
	.size	clz32, .-clz32
	.align	1
	.globl	next_pow2
	.type	next_pow2, @function
next_pow2:
.LFB246:
	.cfi_startproc
	snez	a5,a0
	sub	a0,a0,a5
	srli	a5,a0,1
	or	a5,a5,a0
	srli	a4,a5,2
	or	a4,a4,a5
	srli	a5,a4,4
	or	a5,a5,a4
	srli	a4,a5,8
	or	a4,a4,a5
	srli	a5,a4,16
	or	a5,a5,a4
	srli	a0,a5,32
	or	a0,a0,a5
	addi	a0,a0,1
	ret
	.cfi_endproc
.LFE246:
	.size	next_pow2, .-next_pow2
	.align	1
	.globl	sign_extend
	.type	sign_extend, @function
sign_extend:
.LFB247:
	.cfi_startproc
	li	a4,64
	subw	a4,a4,a1
	li	a5,-1
	addiw	a1,a1,-1
	srl	a5,a5,a4
	li	a4,1
	sll	a4,a4,a1
	and	a5,a5,a0
	xor	a5,a5,a4
	sub	a0,a5,a4
	ret
	.cfi_endproc
.LFE247:
	.size	sign_extend, .-sign_extend
	.align	1
	.globl	sat_add32
	.type	sat_add32, @function
sat_add32:
.LFB249:
	.cfi_startproc
	li	a5,1
	add	a1,a0,a1
	slli	a5,a5,31
	slt	a5,a1,a5
	xori	a5,a5,1
	li	a3,-2147483648
	slli	a5,a5,32
	slt	a4,a1,a3
	srli	a5,a5,32
	neg	a5,a5
	neg	a4,a4
	or	a0,a5,a4
	xori	a2,a3,-1
	and	a5,a5,a2
	and	a4,a4,a3
	not	a0,a0
	and	a0,a0,a1
	or	a5,a5,a4
	or	a0,a0,a5
	sext.w	a0,a0
	ret
	.cfi_endproc
.LFE249:
	.size	sat_add32, .-sat_add32
	.align	1
	.globl	is_pow2_branchy
	.type	is_pow2_branchy, @function
is_pow2_branchy:
.LFB251:
	.cfi_startproc
	beq	a0,zero,.L18
	li	a5,1
	beq	a0,a5,.L16
	andi	a5,a0,1
	bne	a5,zero,.L18
	li	a4,1
	j	.L13
.L14:
	bne	a5,zero,.L18
.L13:
	srli	a0,a0,1
	andi	a5,a0,1
	bne	a0,a4,.L14
.L16:
	li	a0,1
	ret
.L18:
	li	a0,0
	ret
	.cfi_endproc
.LFE251:
	.size	is_pow2_branchy, .-is_pow2_branchy
	.align	1
	.globl	sat_add32_branchy
	.type	sat_add32_branchy, @function
sat_add32_branchy:
.LFB252:
	.cfi_startproc
	li	a5,-2147483648
	add	a1,a0,a1
	xori	a0,a5,-1
	bgt	a1,a0,.L20
	blt	a1,a5,.L22
	sext.w	a0,a1
	ret
.L22:
	li	a0,-2147483648
.L20:
	ret
	.cfi_endproc
.LFE252:
	.size	sat_add32_branchy, .-sat_add32_branchy
	.section	.rodata
	.align	3
	.set	.LANCHOR0,. + 0
	.type	_ZZ5ctz32E9positions, @object
	.size	_ZZ5ctz32E9positions, 32
_ZZ5ctz32E9positions:
	.string	""
	.ascii	"\001\034\002\035\016\030\003\036\026\024\017\031\021\004\b\037"
	.ascii	"\033\r\027\025\023\020\007\032\f\022\006\013\005\n\t"
	.ident	"GCC: (Debian 12.2.0-13) 12.2.0"
	.section	.note.GNU-stack,"",@progbits
