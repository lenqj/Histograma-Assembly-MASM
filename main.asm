.386
.model flat, stdcall
;include pt bibliotecile necesare
includelib msvcrt.lib
extern exit: proc
extern printf: proc
extern scanf: proc
extern fscanf: proc
extern fprintf: proc
extern fopen: proc
extern fclose: proc
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; include pt macro-uri
include min_max.asm
include print.asm
include scan.asm
include histogram.asm
include medie.asm
include interval.asm
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
public start
.data
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; nume fisiere
nume_fisier DB 20 dup(?)
nume_fisier_histograma db "histograma.txt", 0
nume_fisier_medie db "medie.txt", 0
nume_fisier_deviatie db "deviatie.txt", 0
nume_fisier_interval db "interval.txt", 0
nume_fisier_min_max db "min_max.txt", 0
nume_fisier_cerinta db "cerinta.txt", 0
; moduri citire/afisare fisiere
mod_fisier DB "r", 0
mod_fisier_out DB "w+", 0
mod_fisier_append DB "a+", 0
; declarari vectori
hist dword 1024 dup(0)
sir_dif dword 1024 dup(0)
sir_dev dword 1024 dup(0)
sir dword 1024 dup(0)
; declarari lungi vectori
lgsir dword 0
lgsir_minus_1 dword 0
lgdev dword 0
lgsir_hist dword 0
; variabile necesare programului
min dword 0
max dword 0 
sum dword 0
m qword 0
op dword 0
dev dword 0
ok dword 0
float_min dword 0
float_max dword 0
; format pt citiri/afisari
format_string DB "%s", 0
format_min_max DB "> min=%d, max=%d ", 10, 0
format_histogram DB "> %d - %d ori", 10, 0
format_el_sir DB "> #%d - %d", 10, 0
format_int DB "%d", 0
format_fscanf_int DB "%d ", 0
format_float DB "%.3f ", 0
format_dev DB "%.3f ",10, 0
; mesaj operatii
mesaj_locatie DB "> Incarcare fisier:" , 10, 0
mesaj_locatie_fisier DB "> Locatie fisier: ", 0
mesaj_operatie DB "> Selecteaza operatie:", 10, 13, 9, "> 0. Inchide program;", 10, 13, 9,"> 1. Histograma;", 10, 13, 9, "> 2. Calculul mediei bazat pe histograma;", 10, 13, 9, "> 3. Calculul deviatiei standard;", 10, 13, 9, "> 4. Eliminare valori.", 10, 13, 0
mesaj_lungime_sir DB "> Lungimea sirului este: ", 0
mesaj_elemente_sir DB "> Elementele sirului sunt: ", 0
mesaj_suma_sir DB "> Suma sirului este: ", 0
mesaj_medie_sir DB "> Media sirului este: ", 0
mesaj_deviatie_sir DB "> Deviatia standard este: ", 0
mesaj_min_interval DB "> Capatul inferior al intervalului este: ", 0
mesaj_max_interval DB "> Capatul superior al intervalului este: ", 0
mesaj_interval DB "> Intervalul este: [%.3f, %.3f]", 0
mesaj_op_aleasa DB "> Ai ales operatia: ", 0
mesaj_salvat DB "> Salvat in: ", 0
mesaj_eroare_op DB "> Alege una din operatiile 0, 1, 2, 3, 4 pentru a putea continua.", 0
mesaj_eroare_fisier DB "> Alege un alt fisier, deoarece nu exista fisierul ales de tine sau nu ai acces sa-l deschizi.", 0
mesaj_stop DB "> Ai ales sa inchizi programul.", 0
mesaj_cerinta DB "> Cerinta:", 10, 0
mesaj_cerinta1 DB "Sa se realizeze un set de functii pentru operatii pe siruri de numere intregi citite dintr-un fisier text.", 13, 0
mesaj_cerinta2 DB "Numerele se vor citi din fisier, se vor stoca in memorie, apoi se va determina valoarea minima si maxima(care vor fi de asemenea stocate in memorie).", 13, 0
mesaj_cerinta3 DB "Operatiile pe siruri cerute sunt:", 10, 9, "1. Histograma valorilor;", 10, 9, "2. Calculul mediei bazat pe histograma;", 10, 9, "3. Calculul deviatiei standard bazat pe histograma;", 10, 9, "4. Eliminarea din sir a valorilor care sunt in afara intervalului.", 10, 0
mesaj_cerinta4 DB "Utilizatorul va alege o operatie dintr-un meniu de optiuni rezultatul va fi pastrat intr-un fisier.", 10, "Programul va permite realizarea unei serii de operatii pe fisierul initial si pe rezultate intermediare.", 10, 10, 0
; variabile ajutatoare
new_line DB 10, 0
int_min DWORD 0
int_max DWORD 0
dev_teste dword 1
lgdev_float dword 0
aux dword 0
doi dword 2
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;start cod
.code
start:
	show_string mesaj_cerinta
	show_string mesaj_cerinta1
	show_string mesaj_cerinta2
	show_string mesaj_cerinta3
	show_string mesaj_cerinta4
	fprintf_string mod_fisier_out, nume_fisier_cerinta, mesaj_cerinta
	fprintf_string mod_fisier_append, nume_fisier_cerinta, mesaj_cerinta1
	fprintf_string mod_fisier_append, nume_fisier_cerinta, mesaj_cerinta2
	fprintf_string mod_fisier_append, nume_fisier_cerinta, mesaj_cerinta3
	fprintf_string mod_fisier_append, nume_fisier_cerinta, mesaj_cerinta4
	show_string mesaj_locatie
start_real:
	scan_fisier nume_fisier
	mov eax, 1
	mov ok, eax
	fscanf_int mod_fisier, nume_fisier, sir, lgsir, aux, ok
	cmp ok, 0
	jle fisier_inexistent
	minmax sir, lgsir
	show_min_max max, min
	fprintf_2int mod_fisier_out, nume_fisier_min_max, min, max
	show_string mesaj_salvat
	show_string nume_fisier_min_max
	show_string new_line
	show_string mesaj_locatie_fisier
	show_string nume_fisier
	show_string new_line
	histogram sir, hist, lgsir
	medie sir, hist, lgsir, sum, m
	dev_sir_calc sir, lgsir, lgsir_minus_1, m, sir_dif, dev
	dev_min_max_float dev, float_min, float_max
	dev_sir_float sir, lgsir, sir_dev, lgdev_float, float_min, float_max
op_start:
	show_string mesaj_operatie
	scan_int op
	show_string mesaj_op_aleasa
	show_int op
	show_string new_line
	cmp op, 0
	je stop_program
	cmp op, 0
	jl operatie_gresita
	cmp op, 4
	jg operatie_gresita
	cmp op, 1
	jne op2
op1:
	fprintf_hist mod_fisier_out, nume_fisier_histograma, sir, hist, max, lgsir_hist
	show_string mesaj_lungime_sir
	show_int lgsir_hist
	show_string new_line
	mov esi, 0
	h1_loop:
	cmp hist[4*esi], 0
	jle increment
	show_2int hist[4*esi], esi
increment:
	inc esi
    cmp esi, max
	jle h1_loop
	show_string mesaj_salvat
	show_string nume_fisier_histograma
	show_string new_line
	jmp op_start
op2: 
	cmp op, 2
	jne op3
	fprintf_string mod_fisier_out, nume_fisier_medie, mesaj_medie_sir
	fprintf_float mod_fisier_append, nume_fisier_medie, m
	show_string mesaj_suma_sir
	show_int sum
	show_string new_line
	show_string mesaj_medie_sir
	show_medie m
	show_string new_line
	show_string mesaj_salvat
	show_string nume_fisier_medie
	show_string new_line
	jmp op_start
op3:
	cmp op, 3
	jne op4
	fprintf_string mod_fisier_out, nume_fisier_deviatie, mesaj_deviatie_sir
	fprintf_dev mod_fisier_append, nume_fisier_deviatie, dev
	fprintf_string mod_fisier_append, nume_fisier_deviatie, new_line
	fprintf_sir_nou_dev mod_fisier_append, nume_fisier_deviatie, sir_dif, lgsir
	show_string mesaj_salvat
	show_string nume_fisier_deviatie
	show_string new_line
	jmp op_start
op4:
	cmp op, 4
	jne op4
	fprintf_interval mod_fisier_out, nume_fisier_interval, float_min, float_max
	fprintf_string mod_fisier_append, nume_fisier_interval, new_line
	fprintf_sir mod_fisier_append, nume_fisier_interval, sir_dev, lgdev_float
	show_string mesaj_deviatie_sir
	show_float dev
	show_string new_line
	show_string mesaj_min_interval
	show_float float_min
	show_string new_line
	show_string mesaj_max_interval
	show_float float_max
	show_string new_line
	show_string mesaj_lungime_sir
	show_int lgdev_float
	show_string new_line
	mov esi, 0
	cmp lgdev, 0
	je final
	h4_loop:
	show_el_sir sir_dev[4*esi], esi
	inc esi
    cmp esi, lgdev
	jl h4_loop
	final:
	show_string mesaj_salvat
	show_string nume_fisier_interval
	show_string new_line
	jmp op_start
operatie_gresita:
	show_string mesaj_eroare_op
	show_string new_line
	jmp op_start
fisier_inexistent:
	show_string mesaj_eroare_fisier
	show_string new_line
	jmp start_real
stop_program:
	show_string mesaj_stop
end start
