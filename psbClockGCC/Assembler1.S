#include <avr/io.h> 
// O que define a seguir sao necessarios para subtrair 0x20 dos enderecos de I/O. 
#define __SFR_OFFSET 0 
#define H			R17 
#define M			R29 
#define S			R28 // 
#define AUX			R31
#define EDIT			R21
#define KEYBOARD		PINC
#define BUTTON_SKIP		PC5
#define BUTTON_UP		PC4
#define BUTTON_DOWN 	PC3
#define FLAGS			R16
#define MODE_DIR        R19  // Novo registrador para controlar direção (0=incremento, 1=decremento)
#define INT_BIT			0
#define TMR_BIT			1

.section .data 
msg: .asciz "Tempo" 
msg_inc: .asciz "Modo:Inc" 
msg_dec: .asciz "Modo:Dec" 

.section .text 
.org 0x0
rjmp main // reset
.org 0x8
rjmp PCINT1_vect // PCINT1C
.org 0x10
rjmp TIMER1_COMPA_vect
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
	sts PCMSK1, AUX ; Habilita PCINT13, PCINT12 e PCINT11


	;zerando timer 1 em caso de haver lixo
	ldi AUX, 0x00
	sts TCNT1H, AUX   
	sts TCNT1L, AUX 
	
	;Habilitando comparação e Prescaler de 256 para definir a freq como 1Hz 
    	ldi AUX, 0b1100 
    	sts TCCR1B, AUX ;(1<<WGM12)|(1<<CS22) 

	;settando numero de comparação para resetar o timer e chamar a interrupção
	ldi AUX, 0xF4
	sts OCR1AH, AUX
	ldi AUX, 0x23
	sts OCR1A, AUX

	;ativa interrupção por comparação de TIMER1
	ldi AUX, 0b10
   	sts TIMSK1, AUX; 
	
	ldi r18, 0

	sei

	clr H
	clr M
	clr S
	clr MODE_DIR   // Inicializa com inc

	rcall AssemblyLcdClear
	mov R24, H
	rcall assemblyLcdPrintHours
	nop
	mov R24, M
	rcall assemblyLcdPrintMinutes
	nop
	mov R24, S
	rcall assemblyLcdPrintSeconds
	nop
	
	clr EDIT
	
loop:
	sbrc FLAGS, INT_BIT
	rjmp PCINT1_Handler
	sbrc FLAGS, TMR_BIT
	rjmp TIMER1_Handler
	rjmp loop

add_sec:
	cpi EDIT, 0
	BREQ do_add
	ret
do_add:
	cpi S, 59
	breq add_min
	inc S
	ret
add_min:
	clr S 
	cpi M, 59
	breq add_hour
	inc M
	ret
add_hour:
	clr M 
	cpi H, 23
	breq clr_hour
	inc H
	ret
clr_hour:
	clr H // pula de 23h para 0h
	ret
	
decr_sec:
	cpi S, 0
	breq decr_min
	dec S
	rjmp check_zero

decr_min:
	cpi M, 0
	breq decr_hour
	ldi S, 59
	dec M
	rjmp check_zero

decr_hour:
	cpi H, 0
	breq zero
	ldi M, 59
	ldi S, 59
	dec H
	rjmp check_zero

zero:
	clr S
	clr M
	clr H
	rcall finish_timer
	ret

finish_timer:
	sbi PORTD, PD2
	ldi AUX, 0x00
	sts TIMSK1, AUX
	ret

check_zero:
	cpi H, 0
	brne countdown_active
	cpi M, 0
	brne countdown_active
	cpi S, 0
	brne countdown_active
	rcall finish_timer 
	ret

countdown_active:
	cbi PORTD, PD2
	ret

.global TIMER1_COMPA_vect
TIMER1_COMPA_vect:
	sbr FLAGS, (1<<TMR_BIT)
	reti

.global PCINT1_vect
PCINT1_vect:
	sbr FLAGS, (1<<INT_BIT)
	reti

TIMER1_Handler:
	cpi EDIT, 0
	brne handler_exit
	
	sbrs MODE_DIR, 0    
	rjmp add_mode        // MODE_DIR=0 Inc
	rjmp dec_mode        // MODE_DIR=1 Dec

add_mode:
	rcall add_sec
	rjmp handler_exit

dec_mode:
	rcall decr_sec
	rjmp handler_exit

handler_exit:
	cbr FLAGS, (1<<TMR_BIT)
	rjmp end

PCINT1_Handler:
	rcall delay_100ms
	cbr FLAGS, (1<<INT_BIT)
	sbis KEYBOARD, BUTTON_SKIP 
	rjmp skip
	sbis KEYBOARD, BUTTON_UP
	rjmp up
	sbis KEYBOARD, BUTTON_DOWN
	rjmp down
	rjmp end 
skip:
	inc EDIT
	cpi EDIT, 5
	brne skip_end
	clr EDIT
skip_end:
	cpi EDIT, 1
	breq turnTmr1Off
	cpi EDIT, 0
	breq turnTmr1On
	rjmp loop

turnTmr1On:
	cbi PORTD, PD2
	ldi AUX, 0b1
    sts TIMSK1, AUX
	rjmp loop
turnTmr1Off:
	ldi AUX, 0x00
	sts TIMSK1, AUX
	sts TCNT1H, AUX   
	sts TCNT1L, AUX   
	rjmp loop
up:
	cpi EDIT, 4        
	brne seg_up
	ldi MODE_DIR, 1    // Configura para dec
	rjmp end
seg_up:
	cpi EDIT, 1 
	brne min_up       	
	inc S
	cpi S, 60
	brne end       
	clr S             	
	rjmp end
min_up:
	cpi EDIT, 2
	brne h_up         	
	inc M
	cpi M, 60         	
	brne end       
	clr M             	
	rjmp end
h_up:
	cpi EDIT, 3
	brne end
	inc H
	cpi H, 24
	brne end      	
	ldi H, 0         
	rjmp end

down:
	cpi EDIT, 4       
	brne seg_down
	ldi MODE_DIR, 0    //incremento
	rjmp end
seg_down:
	cpi EDIT, 1
	brne min_down  		
	cpi S, 0
	brne dec_seg    	
	ldi S, 59
	rjmp end
dec_seg:
	dec S
	rjmp end

min_down:
	cpi EDIT, 2
	brne h_down   		
	cpi M, 0
	brne dec_min   		
	ldi M, 59      		
	rjmp end
dec_min:
	dec M
	rjmp end

h_down:
	cpi EDIT, 3
	brne end
	cpi H, 0
	brne dec_h  		
	ldi H, 23  	
	rjmp end
dec_h:
	dec H

end:
	ldi AUX, 0b00000000
	sts PCMSK1, AUX 
	push R19
	rcall AssemblyLcdClear
	pop R19
	push R19
	mov r24, MODE_DIR
	rcall assemblyLcdPrintMode
	cpi EDIT, 4
	BREQ cursorMode
returnMode:
	mov r24, H
	rcall assemblyLcdPrintHours
	cpi EDIT, 3
	BREQ cursorHours
returnHours:
	mov r24, M
	rcall assemblyLcdPrintMinutes
	cpi EDIT, 2
	BREQ cursorMinutes
returnMinutes:
	mov r24, S
	rcall assemblyLcdPrintSeconds
	cpi EDIT, 1
	BREQ cursorSeconds
returnSeconds:
	
	pop R19
	
	ldi AUX, 0b00111000
	sts PCMSK1, AUX 
	rjmp loop

cursorMode:
	rcall assemblyLcdCursor
	rjmp returnMode

cursorHours:
	rcall assemblyLcdCursor
	rjmp returnHours

cursorMinutes:
	rcall assemblyLcdCursor
	rjmp returnMinutes

cursorSeconds:
	rcall assemblyLcdCursor
	rjmp returnSeconds

toggle_led:
    sbis PORTD, PD2    
    rjmp turn_on       
    cbi PORTD, PD2     
    ret

turn_on:
    sbi PORTD, PD2     
    ret

delay_100ms:
	ldi R23, 32
delay_3:
	ldi R24, 64
delay_2:
	ldi R25, 10
delay_1:
	dec R25
	brne delay_1
	dec R24
	brne delay_2
	dec R23
	brne delay_3
	ret

.end
