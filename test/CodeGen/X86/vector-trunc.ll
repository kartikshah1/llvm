; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mcpu=x86-64 -mattr=+sse2 | FileCheck %s --check-prefix=SSE --check-prefix=SSE2
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mcpu=x86-64 -mattr=+ssse3 | FileCheck %s --check-prefix=SSE --check-prefix=SSSE3
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mcpu=x86-64 -mattr=+sse4.1 | FileCheck %s --check-prefix=SSE --check-prefix=SSE41
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mcpu=x86-64 -mattr=+avx | FileCheck %s --check-prefix=AVX --check-prefix=AVX1

define <4 x i32> @trunc2x2i64(<2 x i64> %a, <2 x i64> %b) {
; SSE2-LABEL: trunc2x2i64:
; SSE2:       # BB#0: # %entry
; SSE2-NEXT:    shufps {{.*#+}} xmm0 = xmm0[0,2],xmm1[0,2]
; SSE2-NEXT:    retq
;
; SSSE3-LABEL: trunc2x2i64:
; SSSE3:       # BB#0: # %entry
; SSSE3-NEXT:    shufps {{.*#+}} xmm0 = xmm0[0,2],xmm1[0,2]
; SSSE3-NEXT:    retq
;
; SSE41-LABEL: trunc2x2i64:
; SSE41:       # BB#0: # %entry
; SSE41-NEXT:    pshufd {{.*#+}} xmm1 = xmm1[0,1,0,2]
; SSE41-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[0,2,2,3]
; SSE41-NEXT:    pblendw {{.*#+}} xmm0 = xmm0[0,1,2,3],xmm1[4,5,6,7]
; SSE41-NEXT:    retq
;
; AVX-LABEL: trunc2x2i64:
; AVX:       # BB#0: # %entry
; AVX-NEXT:    vpshufd {{.*#+}} xmm1 = xmm1[0,1,0,2]
; AVX-NEXT:    vpshufd {{.*#+}} xmm0 = xmm0[0,2,2,3]
; AVX-NEXT:    vpblendw {{.*#+}} xmm0 = xmm0[0,1,2,3],xmm1[4,5,6,7]
; AVX-NEXT:    retq


entry:
  %0 = trunc <2 x i64> %a to <2 x i32>
  %1 = trunc <2 x i64> %b to <2 x i32>
  %2 = shufflevector <2 x i32> %0, <2 x i32> %1, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  ret <4 x i32> %2
}

define i64 @trunc2i64(<2 x i64> %inval) {
; SSE-LABEL: trunc2i64:
; SSE:       # BB#0: # %entry
; SSE-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[0,2,2,3]
; SSE-NEXT:    movd %xmm0, %rax
; SSE-NEXT:    retq
;
; AVX-LABEL: trunc2i64:
; AVX:       # BB#0: # %entry
; AVX-NEXT:    vpshufd {{.*#+}} xmm0 = xmm0[0,2,2,3]
; AVX-NEXT:    vmovq %xmm0, %rax
; AVX-NEXT:    retq


entry:
  %0 = trunc <2 x i64> %inval to <2 x i32>
  %1 = bitcast <2 x i32> %0 to i64
  ret i64 %1
}

define <8 x i16> @trunc2x4i32(<4 x i32> %a, <4 x i32> %b) {
; SSE2-LABEL: trunc2x4i32:
; SSE2:       # BB#0: # %entry
; SSE2-NEXT:    pshuflw {{.*#+}} xmm1 = xmm1[0,2,2,3,4,5,6,7]
; SSE2-NEXT:    pshufhw {{.*#+}} xmm1 = xmm1[0,1,2,3,4,6,6,7]
; SSE2-NEXT:    pshufd {{.*#+}} xmm1 = xmm1[0,2,2,3]
; SSE2-NEXT:    pshuflw {{.*#+}} xmm0 = xmm0[0,2,2,3,4,5,6,7]
; SSE2-NEXT:    pshufhw {{.*#+}} xmm0 = xmm0[0,1,2,3,4,6,6,7]
; SSE2-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[0,2,2,3]
; SSE2-NEXT:    punpcklqdq {{.*#+}} xmm0 = xmm0[0],xmm1[0]
; SSE2-NEXT:    retq
;
; SSSE3-LABEL: trunc2x4i32:
; SSSE3:       # BB#0: # %entry
; SSSE3-NEXT:    movdqa {{.*#+}} xmm2 = [0,1,4,5,8,9,12,13,8,9,12,13,12,13,14,15]
; SSSE3-NEXT:    pshufb %xmm2, %xmm1
; SSSE3-NEXT:    pshufb %xmm2, %xmm0
; SSSE3-NEXT:    punpcklqdq {{.*#+}} xmm0 = xmm0[0],xmm1[0]
; SSSE3-NEXT:    retq
;
; SSE41-LABEL: trunc2x4i32:
; SSE41:       # BB#0: # %entry
; SSE41-NEXT:    pshufb {{.*#+}} xmm1 = xmm1[0,1,4,5,4,5,6,7,0,1,4,5,8,9,12,13]
; SSE41-NEXT:    pshufb {{.*#+}} xmm0 = xmm0[0,1,4,5,8,9,12,13,8,9,12,13,12,13,14,15]
; SSE41-NEXT:    pblendw {{.*#+}} xmm0 = xmm0[0,1,2,3],xmm1[4,5,6,7]
; SSE41-NEXT:    retq
;
; AVX-LABEL: trunc2x4i32:
; AVX:       # BB#0: # %entry
; AVX-NEXT:    vpshufb {{.*#+}} xmm1 = xmm1[0,1,4,5,4,5,6,7,0,1,4,5,8,9,12,13]
; AVX-NEXT:    vpshufb {{.*#+}} xmm0 = xmm0[0,1,4,5,8,9,12,13,8,9,12,13,12,13,14,15]
; AVX-NEXT:    vpblendw {{.*#+}} xmm0 = xmm0[0,1,2,3],xmm1[4,5,6,7]
; AVX-NEXT:    retq




entry:
  %0 = trunc <4 x i32> %a to <4 x i16>
  %1 = trunc <4 x i32> %b to <4 x i16>
  %2 = shufflevector <4 x i16> %0, <4 x i16> %1, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  ret <8 x i16> %2
}

; PR15524 http://llvm.org/bugs/show_bug.cgi?id=15524
define i64 @trunc4i32(<4 x i32> %inval) {
; SSE2-LABEL: trunc4i32:
; SSE2:       # BB#0: # %entry
; SSE2-NEXT:    pshuflw {{.*#+}} xmm0 = xmm0[0,2,2,3,4,5,6,7]
; SSE2-NEXT:    pshufhw {{.*#+}} xmm0 = xmm0[0,1,2,3,4,6,6,7]
; SSE2-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[0,2,2,3]
; SSE2-NEXT:    movd %xmm0, %rax
; SSE2-NEXT:    retq
;
; SSSE3-LABEL: trunc4i32:
; SSSE3:       # BB#0: # %entry
; SSSE3-NEXT:    pshufb {{.*#+}} xmm0 = xmm0[0,1,4,5,8,9,12,13,8,9,12,13,12,13,14,15]
; SSSE3-NEXT:    movd %xmm0, %rax
; SSSE3-NEXT:    retq
;
; SSE41-LABEL: trunc4i32:
; SSE41:       # BB#0: # %entry
; SSE41-NEXT:    pshufb {{.*#+}} xmm0 = xmm0[0,1,4,5,8,9,12,13,8,9,12,13,12,13,14,15]
; SSE41-NEXT:    movd %xmm0, %rax
; SSE41-NEXT:    retq
;
; AVX-LABEL: trunc4i32:
; AVX:       # BB#0: # %entry
; AVX-NEXT:    vpshufb {{.*#+}} xmm0 = xmm0[0,1,4,5,8,9,12,13,8,9,12,13,12,13,14,15]
; AVX-NEXT:    vmovq %xmm0, %rax
; AVX-NEXT:    retq




entry:
  %0 = trunc <4 x i32> %inval to <4 x i16>
  %1 = bitcast <4 x i16> %0 to i64
  ret i64 %1
}

define <16 x i8> @trunc2x8i16(<8 x i16> %a, <8 x i16> %b) {
; SSE2-LABEL: trunc2x8i16:
; SSE2:       # BB#0: # %entry
; SSE2-NEXT:    movdqa {{.*#+}} xmm2 = [255,255,255,255,255,255,255,255]
; SSE2-NEXT:    pand %xmm2, %xmm1
; SSE2-NEXT:    pand %xmm2, %xmm0
; SSE2-NEXT:    packuswb %xmm1, %xmm0
; SSE2-NEXT:    retq
;
; SSSE3-LABEL: trunc2x8i16:
; SSSE3:       # BB#0: # %entry
; SSSE3-NEXT:    pshufb {{.*#+}} xmm1 = zero,zero,zero,zero,zero,zero,zero,zero,xmm1[0,2,4,6,8,10,12,14]
; SSSE3-NEXT:    pshufb {{.*#+}} xmm0 = xmm0[0,2,4,6,8,10,12,14],zero,zero,zero,zero,zero,zero,zero,zero
; SSSE3-NEXT:    por %xmm1, %xmm0
; SSSE3-NEXT:    retq
;
; SSE41-LABEL: trunc2x8i16:
; SSE41:       # BB#0: # %entry
; SSE41-NEXT:    pshufb {{.*#+}} xmm1 = zero,zero,zero,zero,zero,zero,zero,zero,xmm1[0,2,4,6,8,10,12,14]
; SSE41-NEXT:    pshufb {{.*#+}} xmm0 = xmm0[0,2,4,6,8,10,12,14],zero,zero,zero,zero,zero,zero,zero,zero
; SSE41-NEXT:    por %xmm1, %xmm0
; SSE41-NEXT:    retq
;
; AVX-LABEL: trunc2x8i16:
; AVX:       # BB#0: # %entry
; AVX-NEXT:    vpshufb {{.*#+}} xmm1 = zero,zero,zero,zero,zero,zero,zero,zero,xmm1[0,2,4,6,8,10,12,14]
; AVX-NEXT:    vpshufb {{.*#+}} xmm0 = xmm0[0,2,4,6,8,10,12,14],zero,zero,zero,zero,zero,zero,zero,zero
; AVX-NEXT:    vpor %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq




entry:
  %0 = trunc <8 x i16> %a to <8 x i8>
  %1 = trunc <8 x i16> %b to <8 x i8>
  %2 = shufflevector <8 x i8> %0, <8 x i8> %1, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
  ret <16 x i8> %2
}

; PR15524 http://llvm.org/bugs/show_bug.cgi?id=15524
define i64 @trunc8i16(<8 x i16> %inval) {
; SSE2-LABEL: trunc8i16:
; SSE2:       # BB#0: # %entry
; SSE2-NEXT:    pand {{.*}}(%rip), %xmm0
; SSE2-NEXT:    packuswb %xmm0, %xmm0
; SSE2-NEXT:    movd %xmm0, %rax
; SSE2-NEXT:    retq
;
; SSSE3-LABEL: trunc8i16:
; SSSE3:       # BB#0: # %entry
; SSSE3-NEXT:    pshufb {{.*#+}} xmm0 = xmm0[0,2,4,6,8,10,12,14,u,u,u,u,u,u,u,u]
; SSSE3-NEXT:    movd %xmm0, %rax
; SSSE3-NEXT:    retq
;
; SSE41-LABEL: trunc8i16:
; SSE41:       # BB#0: # %entry
; SSE41-NEXT:    pshufb {{.*#+}} xmm0 = xmm0[0,2,4,6,8,10,12,14,u,u,u,u,u,u,u,u]
; SSE41-NEXT:    movd %xmm0, %rax
; SSE41-NEXT:    retq
;
; AVX-LABEL: trunc8i16:
; AVX:       # BB#0: # %entry
; AVX-NEXT:    vpshufb {{.*#+}} xmm0 = xmm0[0,2,4,6,8,10,12,14,u,u,u,u,u,u,u,u]
; AVX-NEXT:    vmovq %xmm0, %rax
; AVX-NEXT:    retq




entry:
  %0 = trunc <8 x i16> %inval to <8 x i8>
  %1 = bitcast <8 x i8> %0 to i64
  ret i64 %1
}
