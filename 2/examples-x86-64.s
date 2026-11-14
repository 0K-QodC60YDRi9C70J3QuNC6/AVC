	.file	"asm_examples.cpp"
	.intel_syntax noprefix
	.text
	.p2align 4
	.globl	f_and
	.type	f_and, @function
f_and:
.LFB2:
	.cfi_startproc
	movzx	eax, dil
	ret
	.cfi_endproc
.LFE2:
	.size	f_and, .-f_and
	.p2align 4
	.globl	f_or
	.type	f_or, @function
f_or:
.LFB3:
	.cfi_startproc
	mov	eax, edi
	or	eax, 1
	ret
	.cfi_endproc
.LFE3:
	.size	f_or, .-f_or
	.p2align 4
	.globl	f_shl
	.type	f_shl, @function
f_shl:
.LFB4:
	.cfi_startproc
	lea	eax, 0[0+rdi*8]
	ret
	.cfi_endproc
.LFE4:
	.size	f_shl, .-f_shl
	.p2align 4
	.globl	f_sar
	.type	f_sar, @function
f_sar:
.LFB5:
	.cfi_startproc
	mov	eax, edi
	sar	eax, 3
	ret
	.cfi_endproc
.LFE5:
	.size	f_sar, .-f_sar
	.p2align 4
	.globl	f_xor
	.type	f_xor, @function
f_xor:
.LFB6:
	.cfi_startproc
	mov	eax, edi
	shr	eax, 16
	xor	eax, edi
	ret
	.cfi_endproc
.LFE6:
	.size	f_xor, .-f_xor
	.p2align 4
	.globl	d7
	.type	d7, @function
d7:
.LFB7:
	.cfi_startproc
	movsx	rax, edi
	imul	rax, rax, -1840700269
	shr	rax, 32
	add	eax, edi
	sar	edi, 31
	sar	eax, 2
	sub	eax, edi
	ret
	.cfi_endproc
.LFE7:
	.size	d7, .-d7
	.p2align 4
	.globl	m7
	.type	m7, @function
m7:
.LFB8:
	.cfi_startproc
	movsx	rax, edi
	mov	edx, edi
	imul	rax, rax, -1840700269
	sar	edx, 31
	shr	rax, 32
	add	eax, edi
	sar	eax, 2
	sub	eax, edx
	lea	edx, 0[0+rax*8]
	sub	edx, eax
	mov	eax, edi
	sub	eax, edx
	ret
	.cfi_endproc
.LFE8:
	.size	m7, .-m7
	.p2align 4
	.globl	divide
	.type	divide, @function
divide:
.LFB9:
	.cfi_startproc
	mov	eax, edi
	cdq
	idiv	esi
	ret
	.cfi_endproc
.LFE9:
	.size	divide, .-divide
	.p2align 4
	.globl	rotate_xor
	.type	rotate_xor, @function
rotate_xor:
.LFB10:
	.cfi_startproc
	mov	eax, DWORD PTR [rdi]
	xor	eax, DWORD PTR [rsi]
	mov	DWORD PTR [rdi], eax
	xor	eax, DWORD PTR [rsi]
	mov	DWORD PTR [rsi], eax
	xor	DWORD PTR [rdi], eax
	mov	eax, DWORD PTR [rsi]
	xor	eax, DWORD PTR [rdx]
	mov	DWORD PTR [rsi], eax
	xor	eax, DWORD PTR [rdx]
	mov	DWORD PTR [rdx], eax
	xor	DWORD PTR [rsi], eax
	ret
	.cfi_endproc
.LFE10:
	.size	rotate_xor, .-rotate_xor
	.p2align 4
	.globl	rotate_arithmetic
	.type	rotate_arithmetic, @function
rotate_arithmetic:
.LFB11:
	.cfi_startproc
	mov	eax, DWORD PTR [rsi]
	add	eax, DWORD PTR [rdi]
	mov	DWORD PTR [rdi], eax
	mov	ecx, DWORD PTR [rsi]
	mov	r8d, eax
	sub	r8d, ecx
	sub	ecx, eax
	mov	DWORD PTR [rsi], r8d
	add	DWORD PTR [rdi], ecx
	mov	eax, DWORD PTR [rdx]
	add	eax, DWORD PTR [rsi]
	mov	DWORD PTR [rsi], eax
	mov	ecx, DWORD PTR [rdx]
	mov	edi, eax
	sub	edi, ecx
	sub	ecx, eax
	mov	DWORD PTR [rdx], edi
	add	DWORD PTR [rsi], ecx
	ret
	.cfi_endproc
.LFE11:
	.size	rotate_arithmetic, .-rotate_arithmetic
	.p2align 4
	.globl	rotate_temporary
	.type	rotate_temporary, @function
rotate_temporary:
.LFB12:
	.cfi_startproc
	mov	ecx, DWORD PTR [rsi]
	mov	eax, DWORD PTR [rdi]
	mov	DWORD PTR [rdi], ecx
	mov	ecx, DWORD PTR [rdx]
	mov	DWORD PTR [rsi], ecx
	mov	DWORD PTR [rdx], eax
	ret
	.cfi_endproc
.LFE12:
	.size	rotate_temporary, .-rotate_temporary
	.ident	"GCC: (Debian 12.2.0-14+deb12u1) 12.2.0"
	.section	.note.GNU-stack,"",@progbits
