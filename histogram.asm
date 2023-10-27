histogram macro sir, hist, lgsir	
local histogram_loop
	mov esi, 0
	mov edi, lgsir
histogram_loop:
	mov ebx, sir[4*esi]
	inc hist[4*ebx]
	inc esi
	dec edi
    cmp edi,0
jne histogram_loop
endm
histogram_zero macro hist, lgsir	
local histograms_loop
	mov esi, 0
	mov edi, lgsir
histograms_loop:
	mov ebx, 0
	mov hist[4*esi], ebx
	inc esi
	dec edi
    cmp edi,0
	jne histograms_loop
endm