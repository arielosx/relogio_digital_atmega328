#include <avr/io.h> 
 
// O define a seguir Ã© necessÃ¡rio para subtrair 0x20 dos endereÃ§os de I/O. 
#define __SFR_OFFSET 0 
 
#define H				R20 // [0b0000..0b1011]
#define M				R21 // [0b00000..0b111011]
#define S				R22 // [0b00000..0b111011]
#define FLAG_H			R23 // se FLAG_H = 1 entÃ£o "PM", senÃ£o "AM"
#define AUX				R26
#define EDIT			R25
#define KEYBOARD		PINC
#define BUTTON_SKIP		PC5
#define BUTTON_UP		PC4
#define BUTTON_DOWN 	PC3

.section .data 
msg: .asciz "Tempo" 
 
// Aqui inicia o segmento de cÃ³digo
.section .text 

.org 0x0
rjmp main // reset

.org 0x8
rjmp PCINT1_vect // PCINT1C

.global main 
.org 0xF0
main:
	rcall assemblySYSTEM_Initialize
	rcall assemblyLcdInit
	
	ldi r24, 0x14
	rcall assemblyLcdPrintHours
	ldi r24, 0x32
	rcall assemblyLcdPrintMinutes
	ldi r24, 0x09
	rcall assemblyLcdPrintSeconds
 
	ldi AUX, 0b1000111
	out DDRC, AUX // Define PC3, PC4 e PC5 como entradas
	com AUX
	out KEYBOARD, AUX // Zera as saídas da PORTC e ativa os resistores pull-up de PC3, PC4 e PC5

	// Zera os registradores de hora
	ldi H, 1
	clr M
	clr S
	clr FLAG_H // Inicia flag de turno como 0


	ldi AUX, 0b010
	sts PCICR, AUX // Ativa PCINT da porta C 

	ldi AUX, 0b00111000
	sts PCMSK1, AUX // Habilita PCINT13, PCINT12 e PCINT11

	clr EDIT
	sei
loop:
	rjmp loop

add_sec:
	cpi S, 59
	breq add_min
	inc S
	ret
add_min:
	clr S // zera os segundos
	cpi M, 59
	breq add_hour
	inc M
	ret
add_hour:
	clr M // zera os minutos
	cpi H, 12
	breq flip_flag
	inc H
	ret
flip_flag:
	ldi H, 1 // pula de 12h para 1h
	com FLAG_H // inverte a flag (AM/PM)
	ret
	
.global PCINT1_vect
PCINT1_vect:
	sbis KEYBOARD, BUTTON_SKIP // ignora skip se o botão não foi pressionao
	rjmp skip

	sbis KEYBOARD, BUTTON_UP // ignora skip se o botão não foi pressionao
	rjmp up

	sbis KEYBOARD, BUTTON_DOWN // ignora skip se o botão não foi pressionao
	rjmp down
	reti

skip:
	inc EDIT
	cpi EDIT, 3
	brne skip_end
	clr EDIT
skip_end:
	reti

up:
seg_up:
	cpi EDIT, 0 
	brne min_up // pula para min_up se a EDIT != 0
	inc S
	cpi S, 60
	brlt up_end // pula para up_end se S < 60
	clr S // S = 0
	rjmp up_end
min_up:
	cpi EDIT, 1
	brne h_up // pula para h_up se a EDIT != 1
	inc M
	cpi M, 60 // confere se M < 60
	brlt up_end // pula para up_end se M < 60
	clr M // M = 0
	rjmp up_end
h_up:
	cpi EDIT, 2
	brne flip_flag_in_interruption // pula para flip_flag_in_interruption se EDIT != 2
	inc H
	cpi H, 13
	brlt up_end // pula para up_end se H < 13
	ldi H, 1 // H = 1
up_end: // Esta flag não é utilizada quando EDIT = 3
	reti


down:
seg_down:
	cpi EDIT, 0
	brne min_down // pula para min_down se EDIT != 0
	cpi S, 0
	brne seg_dec // pula para seg_dec se S != 0
	ldi S, 59 // S = 59
	rjmp down_end
seg_dec:
	dec S
	rjmp down_end

min_down:
	cpi EDIT, 1
	brne h_down // pula para h_down se EDIT != 1
	cpi M, 0
	brne min_dec // pula para min_dec se M != 0
	ldi M, 59 // M = 59
	rjmp down_end
min_dec:
	dec M
	rjmp down_end

h_down:
	cpi EDIT, 2
	brne flip_flag_in_interruption // pula para flip_flag_in_interruption se EDIT != 2
	cpi H, 1
	brne h_dec // pula para h_dec se H != 1
	ldi H, 12 // H = 12
	rjmp down_end
h_dec:
	dec H
down_end:
	reti

// !!! CUIDADO !!!
// ESTA É A ÚNICA FORMA ALTERNATIVA DE SAIR DE UMA INTERRUPÇÃO
flip_flag_in_interruption:
	rcall flip_flag
	reti
.end