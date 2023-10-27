medie macro sir, hist, lgsir, sum, med	
local sum_loop, sum_hist_loop, sum_dec, sum_minus_final
	push esp
	mov edx, 0
	mov esi, 0
sum_loop:
	mov ebx, sir[4*esi]
	mov eax, ebx
	mov edx, 0
	mov edi, hist[4*ebx]
	imul edi
	add sum, eax
sum_hist_loop:
	cmp edi, 1
	jle sum_minus_final
	mov edx, sir[4*esi]
	mov edi, hist[4*ebx]
sum_dec:
	dec edi
	sub sum, edx
	cmp edi, 1
	jg sum_dec
sum_minus_final:
	inc esi
    cmp esi, lgsir
	jl sum_loop
	finit
	fld sum
	fdiv lgsir
	FSTP med
	pop esp
	
endm
