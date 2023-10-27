minmax macro sir, lgsir
local min_max_loop, cmp_max, urmator
	mov esi, 0
	mov edi, lgsir
	mov ebx, sir[4*esi]
	mov edx, sir[4*esi]
min_max_loop:
	cmp ebx, sir[4*esi]
	JL cmp_max
	mov ebx, sir[4*esi]
	cmp_max:
	cmp edx, sir[4*esi]
	JG urmator
	mov edx, sir[4*esi]
	urmator:
	inc esi	
	dec edi
    cmp edi,0
	jne min_max_loop
	mov min, ebx
	mov max, edx
endm