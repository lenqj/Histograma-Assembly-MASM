show_min_max macro min, max
	push min
	push max
	push offset format_min_max
	call printf
	add esp, 12
endm
show_int macro n
	push n
	push offset format_int
	call printf
	add esp, 4
endm
show_medie macro m
	push dword ptr [m+4]
	push dword ptr [m]
	push offset format_float
	call printf
	add esp, 8
endm
show_float macro n
	sub esp, 8
    fld dword ptr [n]
    fstp qword ptr [esp]
    push offset format_float
	call printf
	add esp, 8
endm

show_2int macro n, n2
	push n
	push n2
	push offset format_histogram
	call printf
	add esp, 12
endm
show_el_sir macro n, n2
	push n
	push n2
	push offset format_el_sir
	call printf
	add esp, 12
endm
show_string macro string
	push offset string
	push offset format_string
	call printf
	add esp, 8
endm
fprintf_sir macro mod_fisier, fisier, sir, lgsir
local print, close_file
	mov esi, 0
	push offset mod_fisier
	push offset fisier
	call fopen
	add esp, 8
	mov edi, eax
print:
	push sir[4*esi]
	push offset format_fscanf_int
	push edi
	call fprintf
	add esp, 12
	inc esi
	cmp esi, lgsir
	jl print
	close_file:
	push edi
	call fclose
endm
fprintf_hist macro mod_fisier, fisier, sir, hist, lgsir, lgsir_hist
local print, increment, close_file
	mov esi, 0
	push offset mod_fisier
	push offset fisier
	call fopen
	add esp, 8
	mov edi, eax
print:	
	cmp hist[4*esi], 0
	jle increment
	inc lgsir_hist
	push hist[4*esi]
	push esi
	push offset format_histogram
	push edi
	call fprintf
	add esp, 12
increment:
	inc esi
	cmp esi, lgsir
	jle print
	close_file:
	push edi
	call fclose
endm
fprintf_2int macro mod_fisier, fisier, n, n2
local print, close_file
	mov esi, 0
	push offset mod_fisier
	push offset fisier
	call fopen
	add esp, 8
	mov edi, eax
	push n
	push n2
	push offset format_min_max
	push edi
	call fprintf
	add esp, 12
	push edi
	call fclose
endm
fprintf_int macro mod_fisier, fisier, n
local print, close_file
	mov esi, 0
	push offset mod_fisier
	push offset fisier
	call fopen
	add esp, 8
	mov edi, eax
	push n
	push offset format_int
	push edi
	call fprintf
	add esp, 8
	push edi
	call fclose
endm
fprintf_float macro mod_fisier, fisier, m
local print, close_file
	mov esi, 0
	push offset mod_fisier
	push offset fisier
	call fopen
	add esp, 8
	mov edi, eax
	push dword ptr [m+4]
	push dword ptr [m]
	push offset format_float
	push edi
	call fprintf
	add esp, 12
	push edi
	call fclose
endm
fprintf_string macro mod_fisier, fisier, string
local print, close_file
	push offset mod_fisier
	push offset fisier
	call fopen
	add esp, 8
	mov edi, eax
	push offset string
	push offset format_string
	push edi
	call fprintf
	add esp, 12
	push edi
	call fclose
endm
fprintf_interval macro mod_fisier, fisier, n, n2
local print, close_file
	mov esi, 0
	push offset mod_fisier
	push offset fisier
	call fopen
	add esp, 8
	mov edi, eax
	sub esp, 8
    fld dword ptr [n]
    fstp qword ptr [esp]
	fld dword ptr [n2]
    fstp qword ptr [esp+8]
	push offset mesaj_interval
	push edi
	call fprintf
	add esp, 12
	push edi
	call fclose
endm
fprintf_sir_nou_dev macro mod_fisier, fisier, sir_nou, lgsir
local print
	mov esi, 0
	push offset mod_fisier
	push offset fisier
	call fopen
	add esp, 8
	mov edi, eax
print:
	sub esp, 8
    fld dword ptr [sir_nou[4*esi]]
    fstp qword ptr [esp]
    push offset format_float
	push edi
    call fprintf
	add esp, 12
	inc esi
	cmp esi, lgsir
	jl print
	push edi
	call fclose
endm
fprintf_dev macro mod_fisier, fisier, dev
	push offset mod_fisier
	push offset fisier
	call fopen
	add esp, 8
	mov edi, eax
	sub esp, 8
    fld dword ptr [dev]
    fstp qword ptr [esp]
    push offset format_float
	push edi
    call fprintf
    add esp, 12
	push edi
	call fclose
endm