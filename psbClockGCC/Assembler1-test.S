#include <avr/io.h> 
 
// O define a seguir é necessário para subtrair 0x20 dos endereços de I/O. 
#define __SFR_OFFSET 0 
 
#define AUX				R26
#define KEYBOARD		PINC
#define BUTTON_SKIP		PC5
#define BUTTON_UP		PC4
#define BUTTON_DOWN		PC3
#define LAST_STATE      R24
#define LAST_BUTTON     R25
#define AUX2            R18
#define AUX3            R19

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
	ldi LAST_BUTTON, 0 ; inicializa LAST_BUTTON com 0
	in LAST_STATE, KEYBOARD ; lê estado atual
	sei
halt: 
	rjmp halt  

.global PCINT1_vect
PCINT1_vect:
    in AUX, KEYBOARD ; lê estado novo atual em aux
    mov AUX2, LAST_STATE ; estado anterior em aux2
    mov LAST_STATE, AUX ; atualiza LAST_STATE para o novo atual

    cp LAST_BUTTON, 0
    breq check ; se LAST_BUTTON for igual a 0, não liga
    cpi LAST_BUTTON, 1
    breq liga_skip
    cpi LAST_BUTTON, 2
    breq liga_up
    cpi LAST_BUTTON, 3
    breq liga_down

    rjmp check

liga_skip:
    sbi PORTB, 1 ; liga skip
    rjmp check

liga_up:
    sbi PORTB, 2 ; liga up
    rjmp check

liga_down:
    sbi PORTB, 3 ; liga down

check: ; verifica a borda de descida
    sbrc AUX2, BUTTON_SKIP
    sbrs AUX, BUTTON_SKIP
    rjmp skip
    sbrc AUX2, BUTTON_UP
    sbrs AUX, BUTTON_UP
    rjmp up
    sbrc AUX2, BUTTON_DOWN
    sbrs AUX, BUTTON_DOWN
    rjmp down

    rjmp end_isr

skip:
    cbi PORTB, 1 ; apaga skip
    ldi LAST_BUTTON, 1
    rjmp end_isr

up:
    cbi PORTB, 2 ; apaga up
    ldi LAST_BUTTON, 2
    rjmp end_isr

down:
    cbi PORTB, 3 ; apaga down
    ldi LAST_BUTTON, 3

end_isr:
    reti
.end
