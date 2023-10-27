dev_min_max_float macro d, i_min, i_max
local 
	finit
	fld d
	fild doi
	fmul
	fst i_max
	fld i_max
	fchs 
	fst i_min
endm
dev_sir_calc macro sir, lgsir, lgsir2, med, sir_nou, dev
local loop_sir, loop_sum
	mov esi, 0
	mov ebp, lgsir
	mov edi, lgsir
	dec edi
	mov lgsir2, edi
loop_sir:
	finit
	fild sir[4*esi]
	fsub med
	fst sir_nou[4*esi]
	fmul sir_nou[4*esi]
	fild lgsir2
	fdiv
	fst sir_nou[4*esi]
	inc esi
	cmp esi, lgsir
jl loop_sir
	mov esi, 0
	finit
	fldz
loop_sum:
	fadd sir_nou[4*esi]
	inc esi
	cmp esi, lgsir
	jl loop_sum
	fst dev
	fldz 
	fld dev
	fsqrt
	fst dev
endm
dev_sir_float macro sir, lgsir, sir_dev, lgdev, i_min, i_max
local min_max_loop, cmp_max, urmator
	mov esi, 0
	mov edi, 0
min_max_loop:
	mov ebp, sir[4*esi]
	finit
	fldz
	fild sir[4*esi]
	fcom i_min
	fstsw ax
	sahf
	jae cmp_max
	mov sir_dev[4*edi], ebp
	inc edi
cmp_max:
	finit
	fldz
	mov eax, 0
	mov ebp, sir[4*esi]
	fild sir[4*esi]
	fcom i_max
	fstsw ax
	sahf
	JBE urmator
	mov sir_dev[4*edi], ebp
	INC EDI
	urmator:
	inc esi
	cmp esi, lgsir
	jl min_max_loop
	mov esi, 0
	mov lgdev, edi
endm