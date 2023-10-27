scan_fisier macro nume_fisier, ok
	push offset nume_fisier
	push offset format_string
	call scanf
	add esp, 8
endm
scan_int macro n
	push offset n
	push offset format_int
	call scanf
	add esp, 8
endm
fscanf_int macro mod_fisier, fisier, sir, lgsir, aux, ok
local read, close_file, fisier_inexistent, final
	push offset mod_fisier
	push offset fisier
	call fopen
	add esp, 8
	cmp eax, 0
	jle fisier_inexistent
	mov edi, eax
	mov esi, 0
read: 
	push offset aux
	push offset format_fscanf_int
	push edi
	call fscanf
	add esp, 12
	mov ebp, aux
	mov sir[4*esi], ebp
	cmp eax, 1
	jl close_file
	inc esi
	jmp read
	close_file:
	mov lgsir, esi
	push edi
	call fclose
	jmp final
fisier_inexistent:
	mov ok, -1
final:
endm