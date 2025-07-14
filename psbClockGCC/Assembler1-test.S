#include <avr/io.h> 
 
// O define a seguir é necessário para subtrair 0x20 dos endereços de I/O. 
#define __SFR_OFFSET 0 
 
#define AUX				R26
#define KEYBOARD		PINC
#define BUTTON_SKIP		PC5
#define BUTTON_UP		PC4
#define BUTTON_DOWN		PC3

.section .data 
msg: .asciz "Tempo" 
 
// Aqui inicia o segmento de código
.section .text 

.org 0x0
rjmp main ; reset

.org 0x8
rjmp PCINT1_vect ; PCINT1C

.global main 
.org 0xF0
main:
	ldi AUX, 0b1000111
	out DDRC, AUX ; Define PC3, PC4 e PC5 como entradas
	com AUX
	out KEYBOARD, AUX ; Zera as saÃ­das da PORTC e ativa os resistores pull-up de PC3, PC4 e PC5

	ldi AUX, 0b010
	sts PCICR, AUX ; Ativa PCINT da porta C

	ldi AUX, 0b00111000
	sts PCMSK1, AUX ; Habilita PCINT13, PCINT12 e PCINT11

	ldi AUX, 0xFF
	out DDRB, AUX
	out PORTB, AUX

	sei
halt: 
	rjmp halt  

.global PCINT1_vect
PCINT1_vect:
	ldi AUX, 0b1110
	out PORTB, AUX

	sbis KEYBOARD, BUTTON_SKIP ; ignora skip se o botão não foi pressionao
	rjmp skip
	sbis KEYBOARD, BUTTON_UP ; ignora skip se o botão não foi pressionao
	rjmp up
	sbis KEYBOARD, BUTTON_DOWN ; ignora skip se o botão não foi pressionao
	rjmp down
	reti
skip:
	cbi PORTB, 1
	reti
up:
	cbi PORTB, 2
	reti
down:
	cbi PORTB, 3
	reti
.end