
/*
 * Assembler1.S
 *
 * Created: 7/11/2025 11:31:47 PM
 *  Author: joao0
 */ 
/*----------------------------------------------------------------------------------- 
O assemblador GCC usa o mesmo pré-processador que o GCC C/C++ compiler.  
Assim ele usa of #include em vez de .include.*/ 
 
#include <avr/io.h> 
 
/* O define a seguir é necessário para subtrair 0x20 dos endereços de I/O. */ 
 
#define __SFR_OFFSET 0 
 
/* O assemblador GCC permite a inicialização de dados no segmento de dados. 
Os dado estão realmente armazenados na memória de programa. O assemblador 
gera um código de partida que copia os dados inicializados na SRAM. */ 
 
.section .data 
msg: .asciz "Tempo" 
 
/* Aqui inicia o segmento de código */ 
.section .text   
 
.global main 
main:
  rcall assemblySYSTEM_Initialize
  rcall assemblyLcdInit

  ldi r24, 0x14
  rcall assemblyLcdPrintHours
  ldi r24, 0x32
  rcall assemblyLcdPrintMinutes
  ldi r24, 0x09
  rcall assemblyLcdPrintSeconds

halt: 
  rjmp halt 
  .end 
/*
	ATENÇÃO!!!!! O LCD TRABALHA COM UM CURSOR, E TODA VEZ QUE VOCÊ FAZ UM PRINT, ELE PRINTA EXATAMENTE NA POSIÇÃO DO CURSOR.
	ASSIM SENDO, SEMPRE QUE QUISER MUDAR A INFORMAÇÃO DA TELA, É MAIS FÁCIL VOCÊ DAR UM CLEAR (TEM UMA FUNÇÃO NO PSB.CPP EM C PRA ISSO)
	VOCÊ CHAMA O CLEAR E DEPOIS IMPRIME TUDO DE NOVO.
*/

//----------------------------------------------------------------------------------- 

//  ldi r16, 0x0C        ; 0b00001100
//  out DDRD, r16        ; Configura PD2 e PD3 como saída
//  out PORTD, r16 

// ESPAÇO ESPAÇO ESPAÇO ESPAÇO HORAS HORAS : MINUTOS MINUTOS : SEGUNDOS SEGUNDOS ESPAÇO ESPAÇO ESPAÇO ESPAÇO

// LED1_SetHigh();