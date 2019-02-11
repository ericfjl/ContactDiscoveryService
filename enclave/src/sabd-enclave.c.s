	.text
	.file	"sabd-enclave.c"
	.section	.rodata.cst32,"aM",@progbits,32
	.p2align	5               # -- Begin function sabd_lookup_hash
.LCPI0_0:
	.quad	-4                      # 0xfffffffffffffffc
	.quad	-3                      # 0xfffffffffffffffd
	.quad	-2                      # 0xfffffffffffffffe
	.quad	-1                      # 0xffffffffffffffff
.LCPI0_1:
	.quad	-8                      # 0xfffffffffffffff8
	.quad	-7                      # 0xfffffffffffffff9
	.quad	-6                      # 0xfffffffffffffffa
	.quad	-5                      # 0xfffffffffffffffb
.LCPI0_2:
	.quad	-12                     # 0xfffffffffffffff4
	.quad	-11                     # 0xfffffffffffffff5
	.quad	-10                     # 0xfffffffffffffff6
	.quad	-9                      # 0xfffffffffffffff7
	.text
	.hidden	sabd_lookup_hash
	.globl	sabd_lookup_hash
	.p2align	4, 0x90
	.type	sabd_lookup_hash,@function
sabd_lookup_hash:                       # @sabd_lookup_hash
	.cfi_startproc
# %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	pushq	%r15
	.cfi_def_cfa_offset 24
	pushq	%r14
	.cfi_def_cfa_offset 32
	pushq	%r13
	.cfi_def_cfa_offset 40
	pushq	%r12
	.cfi_def_cfa_offset 48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	subq	$232, %rsp
	.cfi_def_cfa_offset 288
	.cfi_offset %rbx, -56
	.cfi_offset %r12, -48
	.cfi_offset %r13, -40
	.cfi_offset %r14, -32
	.cfi_offset %r15, -24
	.cfi_offset %rbp, -16
	movl	%ecx, %r14d
	movq	%rdx, %r15
	cmpl	$1, %ecx
	jbe	.LBB0_1
# %bb.5:
	lfence
	leal	-1(%r14), %eax
	lzcntl	%eax, %eax
	movl	$32, %ebp
	subl	%eax, %ebp
	cmpl	$13, %ebp
	ja	.LBB0_6
.LBB0_2:
	movq	%rdi, 48(%rsp)          # 8-byte Spill
	movq	%rsi, 56(%rsp)          # 8-byte Spill
	movq	%r8, 40(%rsp)           # 8-byte Spill
	lfence
	movl	$12, %eax
	shlxl	%ebp, %eax, %esi
	shlq	$3, %rsi
	movl	$64, %edi
	movq	%rsi, 32(%rsp)          # 8-byte Spill
	callq	memalign@PLT
	movq	%rax, %rbx
	movl	$3, %eax
	testq	%rbx, %rbx
	je	.LBB0_29
# %bb.3:
	movq	%r14, 16(%rsp)          # 8-byte Spill
	lfence
	movl	$1, %eax
	shlxl	%ebp, %eax, %r13d
	movq	%r13, %r14
	addq	%r13, %r14
	movl	$64, %edi
	movq	%r14, %rsi
	callq	memalign@PLT
	testq	%rax, %rax
	je	.LBB0_4
# %bb.7:
	movq	%rax, %r12
	lfence
	movl	$0, 12(%rsp)            # 4-byte Folded Spill
	xorl	%edx, %edx
	movq	%rax, %rdi
	movq	%r14, %rsi
	movq	%r14, %rcx
	callq	memset_s@PLT
	movl	16(%rsp), %r14d         # 4-byte Reload
	movl	$255, %edx
	movq	40(%rsp), %rdi          # 8-byte Reload
	movq	%r14, %rsi
	movq	%r14, %rcx
	callq	memset_s@PLT
	xorl	%edx, %edx
	movq	%rbx, %rdi
	movq	32(%rsp), %rsi          # 8-byte Reload
	movq	%rsi, %rcx
	callq	memset_s@PLT
	movl	$-1, %eax
	shlxl	%ebp, %eax, %ebp
	notl	%ebp
.LBB0_8:                                # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_13 Depth 2
                                        #       Child Loop BB0_14 Depth 3
	lfence
	rdrandq	%rax
	jae	.LBB0_10
# %bb.9:                                #   in Loop: Header=BB0_8 Depth=1
	lfence
	rdrandq	%rcx
	jae	.LBB0_10
.LBB0_12:                               #   in Loop: Header=BB0_8 Depth=1
	vmovq	%rax, %xmm0
	vmovq	%rcx, %xmm1
	vpunpcklqdq	%xmm0, %xmm1, %xmm2 # xmm2 = xmm1[0],xmm0[0]
	vaeskeygenassist	$1, %xmm2, %xmm0
	vpslldq	$4, %xmm2, %xmm1        # xmm1 = zero,zero,zero,zero,xmm2[0,1,2,3,4,5,6,7,8,9,10,11]
	vmovdqa	%xmm2, 16(%rsp)         # 16-byte Spill
	vpxor	%xmm1, %xmm2, %xmm1
	vpslldq	$4, %xmm1, %xmm2        # xmm2 = zero,zero,zero,zero,xmm1[0,1,2,3,4,5,6,7,8,9,10,11]
	vpxor	%xmm2, %xmm1, %xmm1
	vpslldq	$4, %xmm1, %xmm2        # xmm2 = zero,zero,zero,zero,xmm1[0,1,2,3,4,5,6,7,8,9,10,11]
	vpshufd	$255, %xmm0, %xmm0      # xmm0 = xmm0[3,3,3,3]
	vpxor	%xmm2, %xmm1, %xmm1
	vpxor	%xmm0, %xmm1, %xmm2
	vaeskeygenassist	$2, %xmm2, %xmm0
	vpslldq	$4, %xmm2, %xmm1        # xmm1 = zero,zero,zero,zero,xmm2[0,1,2,3,4,5,6,7,8,9,10,11]
	vmovdqa	%xmm2, 208(%rsp)        # 16-byte Spill
	vpxor	%xmm1, %xmm2, %xmm1
	vpslldq	$4, %xmm1, %xmm2        # xmm2 = zero,zero,zero,zero,xmm1[0,1,2,3,4,5,6,7,8,9,10,11]
	vpxor	%xmm2, %xmm1, %xmm1
	vpslldq	$4, %xmm1, %xmm2        # xmm2 = zero,zero,zero,zero,xmm1[0,1,2,3,4,5,6,7,8,9,10,11]
	vpshufd	$255, %xmm0, %xmm0      # xmm0 = xmm0[3,3,3,3]
	vpxor	%xmm2, %xmm1, %xmm1
	vpxor	%xmm1, %xmm0, %xmm2
	vaeskeygenassist	$4, %xmm2, %xmm0
	vpslldq	$4, %xmm2, %xmm1        # xmm1 = zero,zero,zero,zero,xmm2[0,1,2,3,4,5,6,7,8,9,10,11]
	vmovdqa	%xmm2, 128(%rsp)        # 16-byte Spill
	vpxor	%xmm1, %xmm2, %xmm1
	vpslldq	$4, %xmm1, %xmm2        # xmm2 = zero,zero,zero,zero,xmm1[0,1,2,3,4,5,6,7,8,9,10,11]
	vpxor	%xmm2, %xmm1, %xmm1
	vpslldq	$4, %xmm1, %xmm2        # xmm2 = zero,zero,zero,zero,xmm1[0,1,2,3,4,5,6,7,8,9,10,11]
	vpshufd	$255, %xmm0, %xmm0      # xmm0 = xmm0[3,3,3,3]
	vpxor	%xmm2, %xmm1, %xmm1
	vpxor	%xmm1, %xmm0, %xmm2
	vaeskeygenassist	$8, %xmm2, %xmm0
	vpslldq	$4, %xmm2, %xmm1        # xmm1 = zero,zero,zero,zero,xmm2[0,1,2,3,4,5,6,7,8,9,10,11]
	vmovdqa	%xmm2, 112(%rsp)        # 16-byte Spill
	vpxor	%xmm1, %xmm2, %xmm1
	vpslldq	$4, %xmm1, %xmm2        # xmm2 = zero,zero,zero,zero,xmm1[0,1,2,3,4,5,6,7,8,9,10,11]
	vpxor	%xmm2, %xmm1, %xmm1
	vpslldq	$4, %xmm1, %xmm2        # xmm2 = zero,zero,zero,zero,xmm1[0,1,2,3,4,5,6,7,8,9,10,11]
	vpshufd	$255, %xmm0, %xmm0      # xmm0 = xmm0[3,3,3,3]
	vpxor	%xmm2, %xmm1, %xmm1
	vpxor	%xmm1, %xmm0, %xmm2
	vaeskeygenassist	$16, %xmm2, %xmm0
	vpslldq	$4, %xmm2, %xmm1        # xmm1 = zero,zero,zero,zero,xmm2[0,1,2,3,4,5,6,7,8,9,10,11]
	vmovdqa	%xmm2, 192(%rsp)        # 16-byte Spill
	vpxor	%xmm1, %xmm2, %xmm1
	vpslldq	$4, %xmm1, %xmm2        # xmm2 = zero,zero,zero,zero,xmm1[0,1,2,3,4,5,6,7,8,9,10,11]
	vpxor	%xmm2, %xmm1, %xmm1
	vpslldq	$4, %xmm1, %xmm2        # xmm2 = zero,zero,zero,zero,xmm1[0,1,2,3,4,5,6,7,8,9,10,11]
	vpshufd	$255, %xmm0, %xmm0      # xmm0 = xmm0[3,3,3,3]
	vpxor	%xmm2, %xmm1, %xmm1
	vpxor	%xmm1, %xmm0, %xmm2
	vaeskeygenassist	$32, %xmm2, %xmm0
	vpslldq	$4, %xmm2, %xmm1        # xmm1 = zero,zero,zero,zero,xmm2[0,1,2,3,4,5,6,7,8,9,10,11]
	vmovdqa	%xmm2, 96(%rsp)         # 16-byte Spill
	vpxor	%xmm1, %xmm2, %xmm1
	vpslldq	$4, %xmm1, %xmm2        # xmm2 = zero,zero,zero,zero,xmm1[0,1,2,3,4,5,6,7,8,9,10,11]
	vpxor	%xmm2, %xmm1, %xmm1
	vpslldq	$4, %xmm1, %xmm2        # xmm2 = zero,zero,zero,zero,xmm1[0,1,2,3,4,5,6,7,8,9,10,11]
	vpshufd	$255, %xmm0, %xmm0      # xmm0 = xmm0[3,3,3,3]
	vpxor	%xmm2, %xmm1, %xmm1
	vpxor	%xmm1, %xmm0, %xmm2
	vaeskeygenassist	$64, %xmm2, %xmm0
	vpslldq	$4, %xmm2, %xmm1        # xmm1 = zero,zero,zero,zero,xmm2[0,1,2,3,4,5,6,7,8,9,10,11]
	vmovdqa	%xmm2, 176(%rsp)        # 16-byte Spill
	vpxor	%xmm1, %xmm2, %xmm1
	vpslldq	$4, %xmm1, %xmm2        # xmm2 = zero,zero,zero,zero,xmm1[0,1,2,3,4,5,6,7,8,9,10,11]
	vpxor	%xmm2, %xmm1, %xmm1
	vpslldq	$4, %xmm1, %xmm2        # xmm2 = zero,zero,zero,zero,xmm1[0,1,2,3,4,5,6,7,8,9,10,11]
	vpshufd	$255, %xmm0, %xmm0      # xmm0 = xmm0[3,3,3,3]
	vpxor	%xmm2, %xmm1, %xmm1
	vpxor	%xmm1, %xmm0, %xmm2
	vaeskeygenassist	$128, %xmm2, %xmm0
	vpslldq	$4, %xmm2, %xmm1        # xmm1 = zero,zero,zero,zero,xmm2[0,1,2,3,4,5,6,7,8,9,10,11]
	vmovdqa	%xmm2, 80(%rsp)         # 16-byte Spill
	vpxor	%xmm1, %xmm2, %xmm1
	vpslldq	$4, %xmm1, %xmm2        # xmm2 = zero,zero,zero,zero,xmm1[0,1,2,3,4,5,6,7,8,9,10,11]
	vpxor	%xmm2, %xmm1, %xmm1
	vpslldq	$4, %xmm1, %xmm2        # xmm2 = zero,zero,zero,zero,xmm1[0,1,2,3,4,5,6,7,8,9,10,11]
	vpshufd	$255, %xmm0, %xmm0      # xmm0 = xmm0[3,3,3,3]
	vpxor	%xmm2, %xmm1, %xmm1
	vpxor	%xmm1, %xmm0, %xmm0
	vaeskeygenassist	$27, %xmm0, %xmm8
	vpslldq	$4, %xmm0, %xmm2        # xmm2 = zero,zero,zero,zero,xmm0[0,1,2,3,4,5,6,7,8,9,10,11]
	vmovdqa	%xmm0, 160(%rsp)        # 16-byte Spill
	vpxor	%xmm2, %xmm0, %xmm2
	vpslldq	$4, %xmm2, %xmm1        # xmm1 = zero,zero,zero,zero,xmm2[0,1,2,3,4,5,6,7,8,9,10,11]
	vpxor	%xmm1, %xmm2, %xmm1
	vpslldq	$4, %xmm1, %xmm2        # xmm2 = zero,zero,zero,zero,xmm1[0,1,2,3,4,5,6,7,8,9,10,11]
	vpshufd	$255, %xmm8, %xmm8      # xmm8 = xmm8[3,3,3,3]
	vpxor	%xmm2, %xmm1, %xmm1
	vpxor	%xmm1, %xmm8, %xmm0
	vaeskeygenassist	$54, %xmm0, %xmm8
	lfence
	vpslldq	$4, %xmm0, %xmm2        # xmm2 = zero,zero,zero,zero,xmm0[0,1,2,3,4,5,6,7,8,9,10,11]
	vmovdqa	%xmm0, 64(%rsp)         # 16-byte Spill
	vpxor	%xmm2, %xmm0, %xmm9
	vpslldq	$4, %xmm9, %xmm2        # xmm2 = zero,zero,zero,zero,xmm9[0,1,2,3,4,5,6,7,8,9,10,11]
	vpxor	%xmm2, %xmm9, %xmm2
	vpslldq	$4, %xmm2, %xmm9        # xmm9 = zero,zero,zero,zero,xmm2[0,1,2,3,4,5,6,7,8,9,10,11]
	vpshufd	$255, %xmm8, %xmm8      # xmm8 = xmm8[3,3,3,3]
	vpxor	%xmm9, %xmm2, %xmm2
	vpxor	%xmm2, %xmm8, %xmm0
	vmovdqa	%xmm0, 144(%rsp)        # 16-byte Spill
	xorl	%eax, %eax
	xorl	%r11d, %r11d
	movq	40(%rsp), %r9           # 8-byte Reload
	movq	56(%rsp), %r8           # 8-byte Reload
	movq	48(%rsp), %r10          # 8-byte Reload
	.p2align	4, 0x90
.LBB0_13:                               #   Parent Loop BB0_8 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_14 Depth 3
	lfence
	vpxor	%xmm11, %xmm11, %xmm11
	xorl	%edx, %edx
	vpxor	%xmm12, %xmm12, %xmm12
	vpxor	%xmm13, %xmm13, %xmm13
	vmovapd	.LCPI0_2(%rip), %ymm14  # ymm14 = [18446744073709551604,18446744073709551605,18446744073709551606,18446744073709551607]
	vmovapd	.LCPI0_1(%rip), %ymm15  # ymm15 = [18446744073709551608,18446744073709551609,18446744073709551610,18446744073709551611]
	vmovapd	.LCPI0_0(%rip), %ymm8   # ymm8 = [18446744073709551612,18446744073709551613,18446744073709551614,18446744073709551615]
	xorl	%ecx, %ecx
	vmovdqa	128(%rsp), %xmm0        # 16-byte Reload
	vmovdqa	112(%rsp), %xmm1        # 16-byte Reload
	vmovdqa	96(%rsp), %xmm6         # 16-byte Reload
	vmovdqa	80(%rsp), %xmm2         # 16-byte Reload
	vmovdqa	64(%rsp), %xmm7         # 16-byte Reload
	.p2align	4, 0x90
.LBB0_14:                               #   Parent Loop BB0_8 Depth=1
                                        #     Parent Loop BB0_13 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	lfence
	vpbroadcastq	(%r15,%rdx,8), %ymm9
	vmovq	(%r15,%rdx,8), %xmm10   # xmm10 = mem[0],zero
	vpxor	16(%rsp), %xmm10, %xmm3 # 16-byte Folded Reload
	vaesenc	208(%rsp), %xmm3, %xmm3 # 16-byte Folded Reload
	vaesenc	%xmm0, %xmm3, %xmm3
	vaesenc	%xmm1, %xmm3, %xmm3
	vaesenc	192(%rsp), %xmm3, %xmm3 # 16-byte Folded Reload
	vaesenc	%xmm6, %xmm3, %xmm3
	vaesenc	176(%rsp), %xmm3, %xmm3 # 16-byte Folded Reload
	vaesenc	%xmm2, %xmm3, %xmm3
	vaesenc	160(%rsp), %xmm3, %xmm3 # 16-byte Folded Reload
	vaesenc	%xmm7, %xmm3, %xmm3
	vaesenclast	144(%rsp), %xmm3, %xmm3 # 16-byte Folded Reload
	vmovd	%xmm3, %esi
	vpcmpeqq	%ymm13, %ymm9, %ymm3
	vextracti128	$1, %ymm3, %xmm4
	vpackssdw	%xmm4, %xmm3, %xmm3
	vpcmpeqq	%ymm12, %ymm9, %ymm4
	vextracti128	$1, %ymm4, %xmm5
	vpackssdw	%xmm5, %xmm4, %xmm4
	vpor	%xmm3, %xmm4, %xmm3
	vpcmpeqq	%ymm11, %ymm9, %ymm4
	vextracti128	$1, %ymm4, %xmm5
	vpackssdw	%xmm5, %xmm4, %xmm4
	vpor	%xmm4, %xmm3, %xmm3
	andl	%ebp, %esi
	xorl	%eax, %esi
	addq	$-1, %rsi
	shrq	$32, %rsi
	vpmovsxdq	%xmm3, %ymm3
	xorl	%edi, %edi
	vtestpd	%ymm3, %ymm3
	sete	%dil
	andl	%edi, %esi
	vblendvpd	%ymm8, %ymm9, %ymm13, %ymm13
	vblendvpd	%ymm15, %ymm9, %ymm12, %ymm12
	vblendvpd	%ymm14, %ymm9, %ymm11, %ymm11
	vmovd	%esi, %xmm3
	vpbroadcastq	%xmm3, %ymm3
	vpaddq	%ymm8, %ymm3, %ymm8
	vpaddq	%ymm15, %ymm3, %ymm15
	vpaddq	%ymm14, %ymm3, %ymm14
	addl	%esi, %ecx
	addq	$1, %rdx
	cmpq	%rdx, %r14
	jne	.LBB0_14
# %bb.15:                               #   in Loop: Header=BB0_13 Depth=2
	lfence
	vpcmpeqd	%ymm3, %ymm3, %ymm3
	vblendvpd	%ymm8, %ymm3, %ymm13, %ymm8
	vblendvpd	%ymm15, %ymm3, %ymm12, %ymm9
	vblendvpd	%ymm14, %ymm3, %ymm11, %ymm11
	leal	(,%rax,4), %edx
	leal	(%rdx,%rdx,2), %edx
	vmovapd	%ymm8, (%rbx,%rdx,8)
	vmovapd	%ymm9, 32(%rbx,%rdx,8)
	vmovapd	%ymm11, 64(%rbx,%rdx,8)
	cmpl	$12, %ecx
	seta	%cl
	orb	%cl, %r11b
	addq	$1, %rax
	cmpq	%r13, %rax
	jb	.LBB0_13
# %bb.16:                               #   in Loop: Header=BB0_8 Depth=1
	lfence
	testb	%r11b, %r11b
	je	.LBB0_19
# %bb.17:                               #   in Loop: Header=BB0_8 Depth=1
	movq	%r11, 16(%rsp)          # 8-byte Spill
	lfence
	xorl	%edx, %edx
	movq	%rbx, %rdi
	movq	32(%rsp), %rsi          # 8-byte Reload
	movq	%rsi, %rcx
	vzeroupper
	callq	memset_s@PLT
	movl	12(%rsp), %eax          # 4-byte Reload
	addl	$1, %eax
	movl	%eax, 12(%rsp)          # 4-byte Spill
	cmpl	$127, %eax
	ja	.LBB0_46
# %bb.18:                               #   in Loop: Header=BB0_8 Depth=1
	lfence
	cmpb	$0, 16(%rsp)            # 1-byte Folded Reload
	jne	.LBB0_8
	jmp	.LBB0_46
.LBB0_10:                               #   in Loop: Header=BB0_8 Depth=1
	lfence
	rdrandq	%rax
	jae	.LBB0_30
# %bb.11:                               #   in Loop: Header=BB0_8 Depth=1
	lfence
	rdrandq	%rcx
	jb	.LBB0_12
.LBB0_30:                               #   in Loop: Header=BB0_8 Depth=1
	lfence
	rdrandq	%rax
	jae	.LBB0_32
# %bb.31:                               #   in Loop: Header=BB0_8 Depth=1
	lfence
	rdrandq	%rcx
	jb	.LBB0_12
.LBB0_32:                               #   in Loop: Header=BB0_8 Depth=1
	lfence
	rdrandq	%rax
	jae	.LBB0_34
# %bb.33:                               #   in Loop: Header=BB0_8 Depth=1
	lfence
	rdrandq	%rcx
	jb	.LBB0_12
.LBB0_34:                               #   in Loop: Header=BB0_8 Depth=1
	lfence
	rdrandq	%rax
	jae	.LBB0_36
# %bb.35:                               #   in Loop: Header=BB0_8 Depth=1
	lfence
	rdrandq	%rcx
	jb	.LBB0_12
.LBB0_36:                               #   in Loop: Header=BB0_8 Depth=1
	lfence
	rdrandq	%rax
	jae	.LBB0_38
# %bb.37:                               #   in Loop: Header=BB0_8 Depth=1
	lfence
	rdrandq	%rcx
	jb	.LBB0_12
.LBB0_38:                               #   in Loop: Header=BB0_8 Depth=1
	lfence
	rdrandq	%rax
	jae	.LBB0_40
# %bb.39:                               #   in Loop: Header=BB0_8 Depth=1
	lfence
	rdrandq	%rcx
	jb	.LBB0_12
.LBB0_40:                               #   in Loop: Header=BB0_8 Depth=1
	lfence
	rdrandq	%rax
	jae	.LBB0_42
# %bb.41:                               #   in Loop: Header=BB0_8 Depth=1
	lfence
	rdrandq	%rcx
	jb	.LBB0_12
.LBB0_42:                               #   in Loop: Header=BB0_8 Depth=1
	lfence
	rdrandq	%rax
	jae	.LBB0_44
# %bb.43:                               #   in Loop: Header=BB0_8 Depth=1
	lfence
	rdrandq	%rcx
	jb	.LBB0_12
.LBB0_44:                               #   in Loop: Header=BB0_8 Depth=1
	lfence
	rdrandq	%rax
	jae	.LBB0_46
# %bb.45:                               #   in Loop: Header=BB0_8 Depth=1
	lfence
	rdrandq	%rcx
	jb	.LBB0_12
.LBB0_46:
	lfence
	movq	%r12, %rdi
	callq	free@PLT
	movq	%rbx, %rdi
	callq	free@PLT
	movl	$1, %eax
	jmp	.LBB0_29
.LBB0_19:
	lfence
	testq	%r8, %r8
	vmovdqa	16(%rsp), %xmm8         # 16-byte Reload
	vmovdqa	208(%rsp), %xmm9        # 16-byte Reload
	vmovdqa	128(%rsp), %xmm10       # 16-byte Reload
	vmovdqa	112(%rsp), %xmm11       # 16-byte Reload
	vmovdqa	192(%rsp), %xmm12       # 16-byte Reload
	vmovdqa	96(%rsp), %xmm7         # 16-byte Reload
	vmovdqa	176(%rsp), %xmm5        # 16-byte Reload
	vmovdqa	80(%rsp), %xmm6         # 16-byte Reload
	vmovdqa	160(%rsp), %xmm0        # 16-byte Reload
	vmovdqa	64(%rsp), %xmm1         # 16-byte Reload
	vmovdqa	144(%rsp), %xmm2        # 16-byte Reload
	je	.LBB0_22
# %bb.20:
	lfence
	xorl	%eax, %eax
	.p2align	4, 0x90
.LBB0_21:                               # =>This Inner Loop Header: Depth=1
	lfence
	vpbroadcastq	(%r10,%rax,8), %ymm3
	vmovq	(%r10,%rax,8), %xmm4    # xmm4 = mem[0],zero
	vpxor	%xmm8, %xmm4, %xmm4
	vaesenc	%xmm9, %xmm4, %xmm4
	vaesenc	%xmm10, %xmm4, %xmm4
	vaesenc	%xmm11, %xmm4, %xmm4
	vaesenc	%xmm12, %xmm4, %xmm4
	vaesenc	%xmm7, %xmm4, %xmm4
	vaesenc	%xmm5, %xmm4, %xmm4
	vaesenc	%xmm6, %xmm4, %xmm4
	vaesenc	%xmm0, %xmm4, %xmm4
	vaesenc	%xmm1, %xmm4, %xmm4
	vaesenclast	%xmm2, %xmm4, %xmm4
	vmovd	%xmm4, %ecx
	andl	%ebp, %ecx
	leal	(,%rcx,4), %edx
	leal	(%rdx,%rdx,2), %edx
	vpcmpeqq	(%rbx,%rdx,8), %ymm3, %ymm4
	vmovmskpd	%ymm4, %esi
	vpcmpeqq	32(%rbx,%rdx,8), %ymm3, %ymm4
	vmovmskpd	%ymm4, %edi
	shll	$4, %edi
	orl	%esi, %edi
	vpcmpeqq	64(%rbx,%rdx,8), %ymm3, %ymm3
	vmovmskpd	%ymm3, %edx
	shll	$8, %edx
	orl	%edi, %edx
	movzwl	(%r12,%rcx,2), %esi
	xorl	$61440, %esi            # imm = 0xF000
	orl	%edx, %esi
	movw	%si, (%r12,%rcx,2)
	addq	$1, %rax
	cmpq	%rax, %r8
	jne	.LBB0_21
.LBB0_22:
	lfence
	xorl	%r8d, %r8d
	.p2align	4, 0x90
.LBB0_23:                               # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_24 Depth 2
	lfence
	vpbroadcastq	(%r15,%r8,8), %ymm0
	xorl	%ecx, %ecx
	xorl	%esi, %esi
	xorl	%edx, %edx
	.p2align	4, 0x90
.LBB0_24:                               #   Parent Loop BB0_23 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	lfence
	movl	%ecx, %edi
	andl	$-4, %edi
	vpcmpeqq	(%rbx,%rdi,8), %ymm0, %ymm1
	vmovmskpd	%ymm1, %ebp
	vpcmpeqq	32(%rbx,%rdi,8), %ymm0, %ymm1
	vmovmskpd	%ymm1, %eax
	shll	$4, %eax
	orl	%ebp, %eax
	vpcmpeqq	64(%rbx,%rdi,8), %ymm0, %ymm1
	vmovmskpd	%ymm1, %edi
	shll	$8, %edi
	orl	%eax, %edi
	andw	(%r12,%rsi,2), %di
	orl	%edi, %edx
	addq	$1, %rsi
	addq	$12, %rcx
	cmpq	%r13, %rsi
	jb	.LBB0_24
# %bb.25:                               #   in Loop: Header=BB0_23 Depth=1
	lfence
	testw	%dx, %dx
	setne	(%r9,%r8)
	addq	$1, %r8
	cmpq	%r14, %r8
	jne	.LBB0_23
# %bb.26:
	lfence
	xorl	%eax, %eax
	vpxor	%xmm0, %xmm0, %xmm0
	xorl	%ecx, %ecx
	.p2align	4, 0x90
.LBB0_27:                               # =>This Inner Loop Header: Depth=1
	lfence
	movw	$-32768, (%r12,%rcx,2)  # imm = 0x8000
	movl	%eax, %edx
	andl	$-4, %edx
	vmovdqa	%ymm0, (%rbx,%rdx,8)
	vmovdqa	%ymm0, 32(%rbx,%rdx,8)
	vmovdqa	%ymm0, 64(%rbx,%rdx,8)
	addq	$1, %rcx
	addq	$12, %rax
	cmpq	%r13, %rcx
	jb	.LBB0_27
# %bb.28:
	lfence
	movq	%r12, %rdi
	vzeroupper
	callq	free@PLT
	movq	%rbx, %rdi
	callq	free@PLT
	xorl	%eax, %eax
.LBB0_29:
	lfence
	addq	$232, %rsp
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%r12
	.cfi_def_cfa_offset 40
	popq	%r13
	.cfi_def_cfa_offset 32
	popq	%r14
	.cfi_def_cfa_offset 24
	popq	%r15
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	retq
.LBB0_1:
	.cfi_def_cfa_offset 288
	lfence
	xorl	%ebp, %ebp
	movl	$0, %eax
	testl	%r14d, %r14d
	jne	.LBB0_2
	jmp	.LBB0_29
.LBB0_6:
	lfence
	movl	$2, %eax
	jmp	.LBB0_29
.LBB0_4:
	lfence
	movq	%rbx, %rdi
	callq	free@PLT
	movl	$3, %eax
	jmp	.LBB0_29
.Lfunc_end0:
	.size	sabd_lookup_hash, .Lfunc_end0-sabd_lookup_hash
	.cfi_endproc
                                        # -- End function
	.hidden	sgxsd_enclave_server_init # -- Begin function sgxsd_enclave_server_init
	.globl	sgxsd_enclave_server_init
	.p2align	4, 0x90
	.type	sgxsd_enclave_server_init,@function
sgxsd_enclave_server_init:              # @sgxsd_enclave_server_init
	.cfi_startproc
# %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	pushq	%r15
	.cfi_def_cfa_offset 24
	pushq	%r14
	.cfi_def_cfa_offset 32
	pushq	%r12
	.cfi_def_cfa_offset 40
	pushq	%rbx
	.cfi_def_cfa_offset 48
	.cfi_offset %rbx, -48
	.cfi_offset %r12, -40
	.cfi_offset %r14, -32
	.cfi_offset %r15, -24
	.cfi_offset %rbp, -16
	testq	%rdi, %rdi
	je	.LBB1_1
# %bb.2:
	movq	%rsi, %r14
	movq	%rdi, %rbx
	lfence
	movl	(%rdi), %eax
	leaq	64(,%rax,8), %r12
	movl	$64, %edi
	movq	%r12, %rsi
	callq	memalign@PLT
	testq	%rax, %rax
	je	.LBB1_3
# %bb.4:
	movq	%rax, %rbp
	lfence
	xorl	%r15d, %r15d
	xorl	%edx, %edx
	movq	%rax, %rdi
	movq	%r12, %rsi
	movq	%r12, %rcx
	callq	memset_s@PLT
	movl	(%rbx), %eax
	movq	$0, (%rbp)
	movl	$0, 8(%rbp)
	movl	%eax, 12(%rbp)
	vxorps	%xmm0, %xmm0, %xmm0
	vmovups	%ymm0, 32(%rbp)
	vmovups	%ymm0, 16(%rbp)
	movq	%rbp, (%r14)
	jmp	.LBB1_5
.LBB1_1:
	lfence
	movl	$2, %r15d
	jmp	.LBB1_5
.LBB1_3:
	lfence
	movl	$3, %r15d
.LBB1_5:
	movl	%r15d, %eax
	popq	%rbx
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r14
	.cfi_def_cfa_offset 24
	popq	%r15
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	vzeroupper
	retq
.Lfunc_end1:
	.size	sgxsd_enclave_server_init, .Lfunc_end1-sgxsd_enclave_server_init
	.cfi_endproc
                                        # -- End function
	.hidden	sgxsd_enclave_server_handle_call # -- Begin function sgxsd_enclave_server_handle_call
	.globl	sgxsd_enclave_server_handle_call
	.p2align	4, 0x90
	.type	sgxsd_enclave_server_handle_call,@function
sgxsd_enclave_server_handle_call:       # @sgxsd_enclave_server_handle_call
	.cfi_startproc
# %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	pushq	%r15
	.cfi_def_cfa_offset 24
	pushq	%r14
	.cfi_def_cfa_offset 32
	pushq	%r13
	.cfi_def_cfa_offset 40
	pushq	%r12
	.cfi_def_cfa_offset 48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	subq	$56, %rsp
	.cfi_def_cfa_offset 112
	.cfi_offset %rbx, -56
	.cfi_offset %r12, -48
	.cfi_offset %r13, -40
	.cfi_offset %r14, -32
	.cfi_offset %r15, -24
	.cfi_offset %rbp, -16
	movq	%fs:40, %rax
	movq	%rax, 48(%rsp)
	movq	(%rcx), %rbp
	testq	%rbp, %rbp
	je	.LBB2_1
# %bb.2:
	lfence
	movl	$2, %ebx
	testq	%rdi, %rdi
	je	.LBB2_10
# %bb.3:
	lfence
	movl	(%rdi), %r13d
	testl	%r13d, %r13d
	je	.LBB2_10
# %bb.4:
	movl	%edx, %r12d
	lfence
	movl	%edx, %eax
	shrl	$3, %eax
	cmpl	%r13d, %eax
	jne	.LBB2_10
# %bb.5:
	lfence
	movl	%r12d, %eax
	andl	$7, %eax
	jne	.LBB2_10
# %bb.6:
	lfence
	movl	12(%rbp), %eax
	subl	8(%rbp), %eax
	cmpl	%eax, %r13d
	ja	.LBB2_10
# %bb.7:
	movq	%rsi, %r14
	lfence
	movl	$56, %edi
	callq	malloc@PLT
	testq	%rax, %rax
	je	.LBB2_8
# %bb.9:
	movq	%rax, %rbx
	lfence
	leaq	112(%rsp), %r15
	movq	32(%r15), %rax
	movq	%rax, 32(%rsp)
	vmovups	(%r15), %ymm0
	vmovups	%ymm0, (%rsp)
	movq	(%rbp), %rcx
	movq	%rax, 32(%rbx)
	vmovups	%ymm0, (%rbx)
	movl	%r13d, 40(%rbx)
	movq	%rcx, 48(%rbx)
	movq	%rbx, (%rbp)
	movl	8(%rbp), %r13d
	leaq	64(%rbp,%r13,8), %rdi
	movl	%r12d, %edx
	movq	%r14, %rsi
	vzeroupper
	callq	memcpy@PLT
	movl	40(%rbx), %eax
	addl	%r13d, %eax
	movl	%eax, 8(%rbp)
	xorl	%ebx, %ebx
	movl	$40, %esi
	xorl	%edx, %edx
	movl	$40, %ecx
	movq	%r15, %rdi
	callq	memset_s@PLT
	jmp	.LBB2_10
.LBB2_1:
	lfence
	movl	$5, %ebx
.LBB2_10:
	lfence
	movq	%fs:40, %rax
	cmpq	48(%rsp), %rax
	jne	.LBB2_12
# %bb.11:
	lfence
	movl	%ebx, %eax
	addq	$56, %rsp
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%r12
	.cfi_def_cfa_offset 40
	popq	%r13
	.cfi_def_cfa_offset 32
	popq	%r14
	.cfi_def_cfa_offset 24
	popq	%r15
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	retq
.LBB2_8:
	.cfi_def_cfa_offset 112
	lfence
	movl	$3, %ebx
	jmp	.LBB2_10
.LBB2_12:
	lfence
	callq	__stack_chk_fail@PLT
.Lfunc_end2:
	.size	sgxsd_enclave_server_handle_call, .Lfunc_end2-sgxsd_enclave_server_handle_call
	.cfi_endproc
                                        # -- End function
	.hidden	sgxsd_enclave_server_terminate # -- Begin function sgxsd_enclave_server_terminate
	.globl	sgxsd_enclave_server_terminate
	.p2align	4, 0x90
	.type	sgxsd_enclave_server_terminate,@function
sgxsd_enclave_server_terminate:         # @sgxsd_enclave_server_terminate
	.cfi_startproc
# %bb.0:
	testq	%rsi, %rsi
	je	.LBB3_1
# %bb.2:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	pushq	%r15
	.cfi_def_cfa_offset 24
	pushq	%r14
	.cfi_def_cfa_offset 32
	pushq	%r13
	.cfi_def_cfa_offset 40
	pushq	%r12
	.cfi_def_cfa_offset 48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	subq	$56, %rsp
	.cfi_def_cfa_offset 112
	.cfi_offset %rbx, -56
	.cfi_offset %r12, -48
	.cfi_offset %r13, -40
	.cfi_offset %r14, -32
	.cfi_offset %r15, -24
	.cfi_offset %rbp, -16
	movq	%rsi, %rbp
	movq	%rdi, %r14
	lfence
	movl	$2, %r15d
	xorl	%r13d, %r13d
	testq	%rdi, %rdi
	movq	%rsi, 48(%rsp)          # 8-byte Spill
	je	.LBB3_3
# %bb.4:
	lfence
	movq	8(%r14), %rbx
	movq	%rbx, %rax
	shrq	$61, %rax
	je	.LBB3_5
.LBB3_3:
	lfence
	xorl	%ecx, %ecx
	jmp	.LBB3_6
.LBB3_1:
	.cfi_def_cfa_offset 8
	lfence
	movl	$5, %eax
	retq
.LBB3_5:
	.cfi_def_cfa_offset 112
	lfence
	movabsq	$2305843009213693951, %r12 # imm = 0x1FFFFFFFFFFFFFFF
	leaq	(,%rbx,8), %rsi
	movq	(%r14), %rdi
	callq	sgx_is_outside_enclave@PLT
	andq	%rbx, %r12
	xorl	%ecx, %ecx
	xorl	%r15d, %r15d
	cmpl	$1, %eax
	setne	%r15b
	cmoveq	%r12, %rcx
	movq	48(%rsp), %rbp          # 8-byte Reload
	addl	%r15d, %r15d
.LBB3_6:
	movl	8(%rbp), %ebx
	testq	%rbx, %rbx
	je	.LBB3_14
# %bb.7:
	movq	%rcx, %rbp
	lfence
	movq	%rbx, %rdi
	callq	malloc@PLT
	movq	%rax, %r12
	testl	%r15d, %r15d
	jne	.LBB3_11
# %bb.8:
	lfence
	testq	%r12, %r12
	je	.LBB3_9
# %bb.10:
	lfence
	movq	(%r14), %rdi
	movq	48(%rsp), %rax          # 8-byte Reload
	leaq	64(%rax), %rdx
	movq	%rbp, %rsi
	movl	%ebx, %ecx
	movq	%r12, %r8
	callq	sabd_lookup_hash
	movl	%eax, %r15d
	jmp	.LBB3_11
.LBB3_9:
	lfence
	movl	$3, %r15d
.LBB3_11:
	lfence
	movq	48(%rsp), %rax          # 8-byte Reload
	movq	(%rax), %rbx
	testq	%rbx, %rbx
	je	.LBB3_12
# %bb.16:
	lfence
	movl	8(%rax), %ebp
	xorl	%r13d, %r13d
	.p2align	4, 0x90
.LBB3_17:                               # =>This Inner Loop Header: Depth=1
	lfence
	testl	%r15d, %r15d
	jne	.LBB3_19
# %bb.18:                               #   in Loop: Header=BB3_17 Depth=1
	lfence
	movl	40(%rbx), %esi
	subl	%esi, %ebp
	leaq	(%r12,%rbp), %rdi
	movq	32(%rbx), %rax
	movq	%rax, 32(%rsp)
	vmovups	(%rbx), %ymm0
	vmovups	%ymm0, (%rsp)
	vzeroupper
	callq	sgxsd_enclave_server_reply@PLT
	testl	%r13d, %r13d
	cmovel	%eax, %r13d
.LBB3_19:                               #   in Loop: Header=BB3_17 Depth=1
	lfence
	movq	48(%rbx), %r14
	movl	$56, %esi
	xorl	%edx, %edx
	movl	$56, %ecx
	movq	%rbx, %rdi
	callq	memset_s@PLT
	movq	%rbx, %rdi
	callq	free@PLT
	movq	%r14, %rbx
	testq	%r14, %r14
	jne	.LBB3_17
	jmp	.LBB3_13
.LBB3_12:
	lfence
	xorl	%r13d, %r13d
.LBB3_13:
	lfence
	movq	%r12, %rdi
	callq	free@PLT
	movq	48(%rsp), %rbp          # 8-byte Reload
.LBB3_14:
	lfence
	movl	12(%rbp), %eax
	leaq	64(,%rax,8), %rsi
	xorl	%edx, %edx
	movq	%rbp, %rdi
	movq	%rsi, %rcx
	callq	memset_s@PLT
	movq	%rbp, %rdi
	callq	free@PLT
	cmpl	$2, %r13d
	movl	$1, %eax
	cmovnel	%r13d, %eax
	testl	%r15d, %r15d
	cmovnel	%r15d, %eax
	addq	$56, %rsp
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%r12
	.cfi_def_cfa_offset 40
	popq	%r13
	.cfi_def_cfa_offset 32
	popq	%r14
	.cfi_def_cfa_offset 24
	popq	%r15
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	retq
.Lfunc_end3:
	.size	sgxsd_enclave_server_terminate, .Lfunc_end3-sgxsd_enclave_server_terminate
	.cfi_endproc
                                        # -- End function

	.ident	"clang version 7.0.1-6 (tags/RELEASE_701/final)"
	.section	".note.GNU-stack","",@progbits
	.addrsig
	.addrsig_sym __stack_chk_fail
