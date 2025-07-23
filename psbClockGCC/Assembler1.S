#include <avr/io.h> 
// O que define a seguir sao necessarios para subtrair 0x20 dos enderecos de I/O. 
#define __SFR_OFFSET 0 
#define H			R20 // [0b0000..0b1011]
#define M			R21 // [0b00000..0b111011]
#define S			R22 // [0b00000..0b111011]
#define FLAG_H			R23 // se FLAG_H = 1 entao "PM", senao "AM"
#define AUX			R26
#define EDIT			R25
#define KEYBOARD		PINC
#define BUTTON_SKIP		PC5
#define BUTTON_UP		PC4
#define BUTTON_DOWN 	        PC3
#define LAST_STATE      	R17
#define LAST_BUTTON    	 	R19
#define AUX2            	R18
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
	ldi r24, 20
	mov H, r24
	rcall assemblyLcdPrintHours
	ldi r24, 40
	mov M, r24
	rcall assemblyLcdPrintMinutes
	ldi r24, 9
	mov S, 9
	rcall assemblyLcdPrintSeconds
	ldi AUX, 0b1000111
	out DDRC, AUX // Define PC3, PC4 e PC5 como entradas
	com AUX
	out KEYBOARD, AUX // Zera as saidas da PORTC e ativa os resistores pull-up de PC3, PC4 e PC5
	// Zera os registradores de hora
	clr FLAG_H // Inicia flag de turno como 0
	ldi AUX, 0b010
	sts PCICR, AUX // Ativa PCINT da porta C 
	ldi AUX, 0b00111000
	sts PCMSK1, AUX // Habilita PCINT13, PCINT12 e PCINT11
	ldi LAST_BUTTON, 0         // Nenhum botao pressionado ainda
	in LAST_STATE, KEYBOARD    // Le o estado inicial dos botoes
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
        in AUX, KEYBOARD      	// Le estado novo atual em aux
        mov AUX2, LAST_STATE   	// Estado anterior em aux2
        mov LAST_STATE, AUX    	// Atualiza LAST_STATE para o novo anterior

check:    			// Verifica a borda de descida
        sbrc AUX2, BUTTON_SKIP
        sbrs AUX, BUTTON_SKIP
        rjmp do_skip
        sbrc AUX2, BUTTON_UP
        sbrs AUX, BUTTON_UP
        rjmp do_up
        sbrc AUX2, BUTTON_DOWN
        sbrs AUX, BUTTON_DOWN
        rjmp do_down

        rjmp end_isr

do_skip:
        ldi LAST_BUTTON, 1
        rjmp skip

do_up:
        ldi LAST_BUTTON, 2
        rjmp up

do_down:
        ldi LAST_BUTTON, 3
        rjmp down

end_isr:
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
	cpi S, 60
	brlt end       	// Pula para up_end se S < 60
	clr S             	// S = 0
	rjmp end
min_up:
	cpi EDIT, 1
	brne h_up         	// Pula para h_up se a EDIT != 1
	inc M
	cpi M, 60         	// Confere se M < 60
	brlt end       	// Pula para up_end se M < 60
	clr M             	// M = 0
	rjmp end
h_up:
	cpi EDIT, 2
	brne flip_flag_in_interruption // Pula para flip_flag_in_interruption se EDIT != 2
	inc H
	cpi H, 13
	brlt end      	// Pula para up_end se H < 13
	ldi H, 1         	// H = 1

down:
seg_down:
	cpi EDIT, 0
	brne min_down  		// Pula para min_down se EDIT != 0
	cpi S, 0
	brne seg_dec    	// Pula para seg_dec se S != 0
	ldi S, 59 // S = 59
	rjmp end
seg_dec:
	dec S
	rjmp end

min_down:
	cpi EDIT, 1
	brne h_down   		// Pula para h_down se EDIT != 1
	cpi M, 0
	brne min_dec   		// Pula para min_dec se M != 0
	ldi M, 59      		// M = 59
	rjmp end
min_dec:
	dec M
	rjmp end

h_down:
	cpi EDIT, 2
	brne flip_flag_in_interruption // Pula para flip_flag_in_interruption se EDIT != 2
	cpi H, 1
	brne h_dec  		// Pula para h_dec se H != 1
	ldi H, 12   		// H = 12
	rjmp end

h_dec:
	dec H
    
end:
	rcall AssemblyLcdClear
	mov r24, H
	rcall assemblyLcdPrintHours
	mov r24, M
	rcall assemblyLcdPrintMinutes
	mov r24, S
	rcall assemblyLcdPrintSeconds
	reti

// !!! CUIDADO !!!
// ESTA É A ÚNICA FORMA ALTERNATIVA DE SAIR DE UMA INTERRUPÇÃO
flip_flag_in_interruption:
	rcall flip_flag
	reti
.end
