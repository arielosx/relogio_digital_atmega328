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

.equ TECLADO = PINC
.equ BUTTON_SKIP = PC4
.equ BUTTON_UP = PC5
.equ BUTTON_DOWN = PC6

.org 0x0
rjmp principal

.org 0x0008
rjmp skip
rjmp up
rjmp down

principal:
	ldi AUX, 0b0001111
	out DDRC, AUX ; Define PC5, PC6 e PC7 como entradas
	com AUX
	out PORTC, AUX ; Zera as saídas da PORTC e ativa os resistores pull-up de PC5, PC6 e PC7
	
	ser	AUX ; AUX = 0xFF
	out DDRB, AUX
	out DDRD, AUX
	
	; Zera os registradores de hora
	clr H
	clr M
	clr S
	clr FLAG_H ; Inicia flag de turno como 0
	
loop:
	rcall delay_1s
	rcall add_sec
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
	cpi S, 11
	breq flip_flag
	inc S
	ret
flip_flag:
	clr H ; zera as horas
	com FLAG_H ; inverte a flag
	ret
	
delay_1s:
	ldi R19, 64
delay_step3:
	ldi R18, 128
delay_step2:
	ldi R17, 255
delay_step1:
	dec R17 ; 1 clock
	brne delay_step1 ;  2 clocks
	dec R18 ; 1 clock
	brne delay_step2
	dec R19
	brne delay_step3
	ret
	
skip:
up:
down:
	reti
