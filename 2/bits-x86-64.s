	.file	"bits.cpp"
	.intel_syntax noprefix
	.text
	.p2align 4
	.globl	bswap32
	.type	bswap32, @function
bswap32:
.LFB240:
	.cfi_startproc
	mov	eax, edi
	bswap	eax
	ret
	.cfi_endproc
.LFE240:
	.size	bswap32, .-bswap32
	.p2align 4
	.globl	is_pow2
	.type	is_pow2, @function
is_pow2:
.LFB241:
	.cfi_startproc
	lea	rax, -1[rdi]
	test	rax, rdi
	sete	dl
	xor	eax, eax
	test	rdi, rdi
	setne	al
	and	eax, edx
	ret
	.cfi_endproc
.LFE241:
	.size	is_pow2, .-is_pow2
	.p2align 4
	.globl	parity32
	.type	parity32, @function
parity32:
.LFB242:
	.cfi_startproc
	mov	eax, edi
	shr	eax, 16
	xor	eax, edi
	mov	edx, eax
	shr	edx, 8
	xor	edx, eax
	mov	eax, edx
	shr	eax, 4
	xor	eax, edx
	mov	edx, eax
	shr	edx, 2
	xor	edx, eax
	mov	eax, edx
	shr	eax
	xor	eax, edx
	and	eax, 1
	ret
	.cfi_endproc
.LFE242:
	.size	parity32, .-parity32
	.p2align 4
	.globl	popcount32
	.type	popcount32, @function
popcount32:
.LFB243:
	.cfi_startproc
	mov	eax, edi
	shr	eax
	and	eax, 1431655765
	sub	edi, eax
	mov	edx, edi
	shr	edi, 2
	and	edx, 858993459
	and	edi, 858993459
	add	edx, edi
	mov	eax, edx
	shr	eax, 4
	add	eax, edx
	and	eax, 252645135
	imul	eax, eax, 16843009
	shr	eax, 24
	ret
	.cfi_endproc
.LFE243:
	.size	popcount32, .-popcount32
	.p2align 4
	.globl	ctz32
	.type	ctz32, @function
ctz32:
.LFB244:
	.cfi_startproc
	mov	eax, edi
	lea	rdx, _ZZ5ctz32E9positions[rip]
	neg	eax
	and	eax, edi
	imul	eax, eax, 125613361
	shr	eax, 27
	cmp	edi, 1
	movzx	edx, BYTE PTR [rdx+rax]
	sbb	eax, eax
	mov	ecx, edx
	xor	ecx, 32
	movzx	ecx, cl
	and	eax, ecx
	xor	eax, edx
	ret
	.cfi_endproc
.LFE244:
	.size	ctz32, .-ctz32
	.p2align 4
	.globl	clz32
	.type	clz32, @function
clz32:
.LFB245:
	.cfi_startproc
	mov	eax, edi
	xor	r8d, r8d
	mov	edx, edi
	mov	esi, edi
	shr	eax, 16
	sete	r8b
	sal	r8d, 4
	mov	ecx, r8d
	sal	edx, cl
	mov	eax, edx
	shr	eax, 24
	sete	al
	movzx	eax, al
	sal	eax, 3
	mov	ecx, eax
	sal	edx, cl
	xor	ecx, ecx
	mov	edi, edx
	shr	edi, 28
	sete	cl
	sal	ecx, 2
	sal	edx, cl
	mov	edi, edx
	shr	edi, 30
	sete	dil
	movzx	edi, dil
	add	edi, edi
	cmp	esi, 1
	adc	eax, r8d
	add	eax, ecx
	mov	ecx, edi
	sal	edx, cl
	add	eax, edi
	not	edx
	shr	edx, 31
	add	eax, edx
	ret
	.cfi_endproc
.LFE245:
	.size	clz32, .-clz32
	.p2align 4
	.globl	next_pow2
	.type	next_pow2, @function
next_pow2:
.LFB246:
	.cfi_startproc
	cmp	rdi, 1
	adc	rdi, -1
	mov	rdx, rdi
	shr	rdx
	or	rdx, rdi
	mov	rax, rdx
	shr	rax, 2
	or	rax, rdx
	mov	rdx, rax
	shr	rdx, 4
	or	rdx, rax
	mov	rax, rdx
	shr	rax, 8
	or	rax, rdx
	mov	rdx, rax
	shr	rdx, 16
	or	rdx, rax
	mov	rax, rdx
	shr	rax, 32
	or	rax, rdx
	add	rax, 1
	ret
	.cfi_endproc
.LFE246:
	.size	next_pow2, .-next_pow2
	.p2align 4
	.globl	sign_extend
	.type	sign_extend, @function
sign_extend:
.LFB247:
	.cfi_startproc
	lea	ecx, -1[rsi]
	mov	rax, rdi
	mov	edi, 1
	mov	rdx, -1
	sal	rdi, cl
	mov	ecx, 64
	sub	ecx, esi
	shr	rdx, cl
	and	rax, rdx
	xor	rax, rdi
	sub	rax, rdi
	ret
	.cfi_endproc
.LFE247:
	.size	sign_extend, .-sign_extend
	.p2align 4
	.globl	sat_add32
	.type	sat_add32, @function
sat_add32:
.LFB249:
	.cfi_startproc
	movsx	rsi, esi
	movsx	rdi, edi
	xor	edx, edx
	add	rdi, rsi
	cmp	rdi, 2147483647
	setg	dl
	xor	ecx, ecx
	neg	rdx
	cmp	rdi, -2147483648
	setl	cl
	mov	rax, rdx
	and	edx, 2147483647
	neg	rcx
	or	rax, rcx
	and	rcx, -2147483648
	not	rax
	or	rdx, rcx
	and	rax, rdi
	or	eax, edx
	ret
	.cfi_endproc
.LFE249:
	.size	sat_add32, .-sat_add32
	.p2align 4
	.globl	is_pow2_branchy
	.type	is_pow2_branchy, @function
is_pow2_branchy:
.LFB251:
	.cfi_startproc
	xor	eax, eax
	test	rdi, rdi
	je	.L11
	cmp	rdi, 1
	je	.L16
	test	dil, 1
	je	.L13
	jmp	.L20
	.p2align 4,,10
	.p2align 3
.L14:
	test	dil, 1
	jne	.L18
.L13:
	shr	rdi
	cmp	rdi, 1
	jne	.L14
.L16:
	mov	eax, 1
	ret
	.p2align 4,,10
	.p2align 3
.L18:
	xor	eax, eax
.L11:
	ret
.L20:
	ret
	.cfi_endproc
.LFE251:
	.size	is_pow2_branchy, .-is_pow2_branchy
	.p2align 4
	.globl	sat_add32_branchy
	.type	sat_add32_branchy, @function
sat_add32_branchy:
.LFB252:
	.cfi_startproc
	movsx	rdi, edi
	movsx	rsi, esi
	mov	eax, 2147483647
	add	rdi, rsi
	cmp	rdi, 2147483647
	jg	.L21
	cmp	rdi, -2147483648
	mov	eax, -2147483648
	cmovge	eax, edi
.L21:
	ret
	.cfi_endproc
.LFE252:
	.size	sat_add32_branchy, .-sat_add32_branchy
	.section	.rodata
	.align 32
	.type	_ZZ5ctz32E9positions, @object
	.size	_ZZ5ctz32E9positions, 32
_ZZ5ctz32E9positions:
	.string	""
	.ascii	"\001\034\002\035\016\030\003\036\026\024\017\031\021\004\b\037"
	.ascii	"\033\r\027\025\023\020\007\032\f\022\006\013\005\n\t"
	.ident	"GCC: (Debian 12.2.0-14+deb12u1) 12.2.0"
	.section	.note.GNU-stack,"",@progbits
