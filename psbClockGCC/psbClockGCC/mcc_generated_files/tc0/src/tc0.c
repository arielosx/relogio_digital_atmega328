/**
  * TC0 Generated Driver File
  *
  * @file tc0.c
  *
  * @ingroup tc0
  *
  * @brief This file contains the API implementations for the TC0 module driver.
  *
  * @version TC0 Driver Version 1.0.0
*/

/*
© [2025] Microchip Technology Inc. and its subsidiaries.

    Subject to your compliance with these terms, you may use Microchip 
    software and any derivatives exclusively with Microchip products. 
    You are responsible for complying with 3rd party license terms  
    applicable to your use of 3rd party software (including open source  
    software) that may accompany Microchip software. SOFTWARE IS ?AS IS.? 
    NO WARRANTIES, WHETHER EXPRESS, IMPLIED OR STATUTORY, APPLY TO THIS 
    SOFTWARE, INCLUDING ANY IMPLIED WARRANTIES OF NON-INFRINGEMENT,  
    MERCHANTABILITY, OR FITNESS FOR A PARTICULAR PURPOSE. IN NO EVENT 
    WILL MICROCHIP BE LIABLE FOR ANY INDIRECT, SPECIAL, PUNITIVE, 
    INCIDENTAL OR CONSEQUENTIAL LOSS, DAMAGE, COST OR EXPENSE OF ANY 
    KIND WHATSOEVER RELATED TO THE SOFTWARE, HOWEVER CAUSED, EVEN IF 
    MICROCHIP HAS BEEN ADVISED OF THE POSSIBILITY OR THE DAMAGES ARE 
    FORESEEABLE. TO THE FULLEST EXTENT ALLOWED BY LAW, MICROCHIP?S 
    TOTAL LIABILITY ON ALL CLAIMS RELATED TO THE SOFTWARE WILL NOT 
    EXCEED AMOUNT OF FEES, IF ANY, YOU PAID DIRECTLY TO MICROCHIP FOR 
    THIS SOFTWARE.
*/
#include <avr/io.h>
#include "../tc0.h"

int8_t LcdTimer_Initialize(void) 
{
    //Compare A
    OCR0A = 0x3;

    //Compare B
    OCR0B = 0x0;

    //Count
    TCNT0 = 0x0;

    //PSRSYNC disabled; TSM disabled; 
    GTCCR = 0x0;

    //COM0A 0; COM0B 0; WGM0 2; 
    TCCR0A = 0x2;

    //CS0 RUNNING_NO_PRESCALING; FOC0A disabled; FOC0B disabled; WGM02 0; 
    TCCR0B = 0x1;

    //OCIE0A enabled; OCIE0B disabled; TOIE0 disabled; 
    TIMSK0 = 0x2;

    return 0;
}

bool LcdTimer_Get_Overflow_InterruptFlagStatus(void)
{
    if (TIFR0  & TOV0) {
        return true;
    } else {
        return false;
    }
}

bool LcdTimer_Get_CompareA_InterruptFlagStatus(void)
{
    if (TIFR0  & OCF0A) {
        return true;
    } else {
        return false;
    }
}

bool LcdTimer_Get_CompareB_InterruptFlagStatus(void)
{
    if (TIFR0  & OCF0B) {
        return true;
    } else {
        return false;
    }
}

void LcdTimer_Enable_Overflow_Interrupt(void)
{
    TIMSK0 |= (1 << TOIE0);
}

void LcdTimer_Disable_Overflow_Interrupt(void)
{
    TIMSK0 &= (1 << TOIE0);
}

void LcdTimer_Enable_CompareA_Interrupt(void)
{
    TIMSK0 |= (1 << OCIE0A);
}

void LcdTimer_Disable_CompareA_Interrupt(void)
{
    TIMSK0 &= (1 << OCIE0A);
}

void LcdTimer_Enable_CompareB_Interrupt(void)
{
    TIMSK0 |= (1 << OCIE0B); 
}

void LcdTimer_Disable_CompareB_Interrupt(void)
{
    TIMSK0 &= (1 << OCIE0B);
}

void LcdTimer_WriteTimer(uint8_t timerValue)
{
    TCNT0 = timerValue;
}

uint8_t LcdTimer_ReadTimer(void)
{
    return TCNT0;
}

ISR(TIMER0_COMPA_vect)
{
	timer_us ++;
    //clears the Compare A interrupt flag
    TIFR0 = OCF0A;
    /* Insert your Compare A interrupt handling code here */
    
}


