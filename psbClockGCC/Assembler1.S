#include <avr/io.h> 
// O que define a seguir sao necessarios para subtrair 0x20 dos enderecos de I/O. 
#define __SFR_OFFSET 0 
#define H			R30 // [0b0000..0b1011]
#define M			R29 // [0b00000..0b111011]
#define S			R28 // [0b00000..0b111011]
#define AUX			R26
#define EDIT			R31
#define KEYBOARD		PINC
#define BUTTON_SKIP		PC5
#define BUTTON_UP		PC4
#define BUTTON_DOWN 	PC3
.section .data 
msg: .asciz "Tempo" 
 
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

	ldi r16, (1<<PD2)
    out DDRD, r16
	ldi r16, 0
	cbi PORTD, PD2

	ldi AUX, 0b1000111
	out DDRC, AUX // Define PC3, PC4 e PC5 como entradas
	com AUX
	out KEYBOARD, AUX // Zera as saidas da PORTC e ativa os resistores pull-up de PC3, PC4 e PC5


	ldi AUX, 0b010
	sts PCICR, AUX // Ativa PCINT da porta C 
	ldi AUX, 0b00111000
	sts PCMSK1, AUX // Habilita PCINT13, PCINT12 e PCINT11
	sei

	clr H
	clr M
	clr S
	clr EDIT

	mov R24, H
	rcall assemblyLcdPrintHours
	nop
	mov R24, M
	rcall assemblyLcdPrintMinutes
	nop
	mov R24, S
	rcall assemblyLcdPrintSeconds
	nop
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
	cpi H, 23
	breq clr_hour
	inc H
	ret
clr_hour:
	clr H // pula de 23h para 0h
	ret
	
.global PCINT1_vect
PCINT1_vect:
		// verifica qual botão foi acionado
		sbis KEYBOARD, BUTTON_SKIP 
		rjmp skip
		sbis KEYBOARD, BUTTON_UP
		rjmp up
		sbis KEYBOARD, BUTTON_DOWN
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
	brne min_up       	// Pula para min_up se a EDIT != 0
	inc S
	rcall toggle_led
	cpi S, 60
	brne end       	// Pula para up_end se S < 60
	clr S             	// S = 0
	rjmp end
min_up:
	cpi EDIT, 1
	breq h_up         	// Pula para h_up se a EDIT != 1
	inc M
	cpi M, 60         	// Confere se M < 60
	brne end       	// Pula para up_end se M < 60
	clr M             	// M = 0
	rjmp end
h_up:
	inc H
	cpi H, 24
	brne end      	// Pula para up_end se H < 13
	ldi H, 0         	// H = 0

down:
seg_down:
	cpi EDIT, 0
	brne min_down  		// Pula para min_down se EDIT != 0
	cpi S, 0
	brne dec_seg    	// Pula para dec_seg se S != 0
	ldi S, 59 // S = 59
	rjmp end
dec_seg:
	dec S
	rjmp end

min_down:
	cpi EDIT, 1
	brne h_down   		// Pula para h_down se EDIT != 1
	cpi M, 0
	brne dec_min   		// Pula para dec_min se M != 0
	ldi M, 59      		// M = 59
	rjmp end
dec_min:
	dec M
	rjmp end

h_down:
	cpi H, 0
	brne dec_h  		// Pula para dec_h se H != 0
	ldi H, 23  		// H = 23
	rjmp end
dec_h:
	dec H
	    
end:
	rcall AssemblyLcdClear
	nop
	mov r24, H
	rcall assemblyLcdPrintHours
	mov r24, M
	rcall assemblyLcdPrintMinutes
	mov r24, S
	rcall assemblyLcdPrintSeconds
	nop
	reti

toggle_led:
    tst   r16
    breq  turn_on 
    cbi   PORTD, PD2
    ldi   r16, 0 
    ret

turn_on:
    sbi   PORTD, PD2
    ldi   r16, 1
    ret

.end
