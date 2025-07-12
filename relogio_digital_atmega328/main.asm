; Este programa prevê a utilização das 3 portas como saídas
; Apenas os 3 pinos MSB da porta C são entradas
.nolist
.include "../include/m328pdef.inc"
.list

.def H = R20 ; [0b0000..0b1011]
.def M = R21 ; [0b00000..0b111011]
.def S = R22 ; [0b00000..0b111011]
.def FLAG_H = R23
.def AUX = R24

.equ KEYBOARD = PINC
.equ BUTTON_SKIP = PC5
.equ BUTTON_UP = PC4
.equ BUTTON_DOWN = PC3

.org 0x0
rjmp principal ; reset

.org 0x8
rjmp edit_clock ; PCINT1C

.org 0x0F0
principal:
	ldi AUX, 0b1000111
	out DDRC, AUX ; Define PC3, PC4 e PC5 como entradas
	com AUX
	out KEYBOARD, AUX ; Zera as saídas da PORTC e ativa os resistores pull-up de PC3, PC4 e PC5

	; Zera os registradores de hora
	ldi H, 1
	clr M
	clr S
	clr FLAG_H ; Inicia flag de turno como 0


	ldi AUX, 0b010
	sts PCICR, AUX ; Ativa PCINT da porta C 

	ldi AUX, 0b00111000
	sts PCMSK1, AUX ; Habilita PCINT13, PCINT12 e PCINT11

	clr AUX
	sei
loop:
	rjmp loop

add_sec:
	cpi S, 59
	breq add_min
	inc S
	ret
add_min:
	clr S ; zera os segundos
	cpi M, 59
	breq add_hour
	inc M
	ret
add_hour:
	clr M ; zera os minutos
	cpi H, 12
	breq flip_flag
	inc H
	ret
flip_flag:
	ldi H, 1 ; pula de 12h para 1h
	com FLAG_H ; inverte a flag (AM/PM)
	ret
	

edit_clock:
	sbis KEYBOARD, BUTTON_SKIP ; ignora skip se o botão não foi pressionao
	rjmp skip

	sbis KEYBOARD, BUTTON_UP ; ignora skip se o botão não foi pressionao
	rjmp up

	sbis KEYBOARD, BUTTON_DOWN ; ignora skip se o botão não foi pressionao
	rjmp down
	reti

skip:
	; inserir código
	rjmp return_change_timer
up:
	; inserir código
	rjmp return_change_timer
down:
	; inserir código

return_change_timer:
	reti
