#include <avr/io.h> 
// O que define a seguir sao necessarios para subtrair 0x20 dos enderecos de I/O. 
#define __SFR_OFFSET 0 
#define H			R17 // [0b0000..0b1011]
#define M			R29 // [0b00000..0b111011]
#define S			R28 // [0b00000..0b111011]
#define AUX			R31
#define EDIT			R21
#define KEYBOARD		PINC
#define BUTTON_SKIP		PC5
#define BUTTON_UP		PC4
#define BUTTON_DOWN 	PC3
#define FLAGS			R16
#define INT_BIT			0
#define TMR_BIT			1
.section .data 
msg: .asciz "Tempo" 
 
.section .text 
.org 0x0
rjmp main // reset
.org 0x8
rjmp PCINT1_vect // PCINT1C
.org 0x10
rjmp TIMER1_OVF_vect
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

	
	;Prescaler de 256 para definir a freq como 1Hz 
    ldi AUX, 0b100 
    sts TCCR1B, AUX ;(1<<CS22)|(1<<CS21)
	
	; ativa interrupção por overflow de TIMER1
	ldi AUX, 0b1
    sts TIMSK1, AUX
	ldi AUX, 0x00
	sts TCNT1H, AUX   
	sts TCNT1L, AUX 
	
	ldi r18, 0

	sei

	clr H
	clr M
	clr S
	
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
	cpi EDIT, 4
	breq do_add
	rjmp stopped
stopped:
	ret
do_add:
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

.global TIMER1_OVF_vect
TIMER1_OVF_vect:
	sbr FLAGS, (1<<TMR_BIT)
	reti

.global PCINT1_vect
PCINT1_vect:
	sbr FLAGS, (1<<INT_BIT)
	reti



TIMER1_Handler:
	cpi  EDIT, 5
	breq dec_mode

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
	cpi EDIT, 6
	brne skip_end
	clr EDIT
skip_end:
	cpi EDIT, 1
	breq turnTmr1Off
	cpi EDIT, 0
	breq turnTmr1On
	cpi EDIT, 4
	breq turnTmr1On
	cpi EDIT, 5
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
seg_up:
	cpi EDIT, 1 
	brne min_up       	// Pula para min_up se a EDIT != 0
	inc S
	cpi S, 60
	brne end       	// Pula para up_end se S < 60
	clr S             	// S = 0
	rjmp end
min_up:
	cpi EDIT, 2
	brne h_up         	// Pula para h_up se a EDIT != 1
	inc M
	cpi M, 60         	// Confere se M < 60
	brne end       	// Pula para up_end se M < 60
	clr M             	// M = 0
	rjmp end
h_up:
	cpi EDIT, 3
	brne end
	inc H
	cpi H, 24
	brne end      	// Pula para up_end se H < 13
	ldi H, 0         	// H = 0
	rjmp end

down:
seg_down:
	cpi EDIT, 1
	brne min_down  		// Pula para min_down se EDIT != 0
	cpi S, 0
	brne dec_seg    	// Pula para dec_seg se S != 0
	ldi S, 59 // S = 59
	rjmp end
dec_seg:
	dec S
	rjmp end

min_down:
	cpi EDIT, 2
	brne h_down   		// Pula para h_down se EDIT != 1
	cpi M, 0
	brne dec_min   		// Pula para dec_min se M != 0
	ldi M, 59      		// M = 59
	rjmp end
dec_min:
	dec M
	rjmp end

h_down:
	cpi EDIT, 3
	brne end
	cpi H, 0
	brne dec_h  		// Pula para dec_h se H != 0
	ldi H, 23  		// H = 23
	rjmp end
dec_h:
	dec H
	    
end:
	ldi AUX, 0b00000000
	sts PCMSK1, AUX 
	//sts TIMSK1, AUX
	ldi AUX, 0x00
	//sts TCNT1H, AUX   
	//sts TCNT1L, AUX 
	rcall AssemblyLcdClear
	mov r24, H
	nop
	rcall assemblyLcdPrintHours
	cpi EDIT, 3
	BREQ cursorHours
returnHours:
	mov r24, M
	nop
	rcall assemblyLcdPrintMinutes
	cpi EDIT, 2
	BREQ cursorMinutes
returnMinutes:
	mov r24, S
	rcall assemblyLcdPrintSeconds
	cpi EDIT, 1
	BREQ cursorSeconds
returnSeconds:
	nop
	ldi AUX, 0b00111000
	sts PCMSK1, AUX 
	ldi AUX, 0b1
	//sts TIMSK1, AUX
	rjmp loop

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
    sbis PORTD, PD2    ; Se o bit estiver SET (1), pula a próxima linha
    rjmp turn_on       ; Se estiver CLEAR (0), acende
    cbi PORTD, PD2     ; Apaga o LED
    ret

turn_on:
    sbi PORTD, PD2     ; Acende o LED
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
