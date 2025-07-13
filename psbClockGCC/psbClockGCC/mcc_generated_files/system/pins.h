/**
 * Generated Pins Header File
 * 
 * @file pins.h
 * 
 * @defgroup  pinsdriver Pins Driver
 * 
 * @brief This file contains the API prototypes and function macros for the Pins driver.
 *
 * @version Driver Version  1.0.0
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

#ifndef PINS_H_INCLUDED
#define PINS_H_INCLUDED

#include <avr/io.h>
#include "./port.h"
/**  
 * @ingroup  pinsdriver
 * @name Pin Function Macros
 * Macros for the individual pin functions.
 * @note These sets of macros are generated for all the selected pins in the Pins module.
 */
 ///@{

//get/set d0 aliases
#define d0_SetHigh() do { PORTB |= 0x1; } while(0)
#define d0_SetLow() do { PORTB &= ~0x1; } while(0)
#define d0_Toggle() do { PINB |= 0x1; } while(0)
#define d0_GetValue() (PINB & (0x1 << 0))
#define d0_SetDigitalInput() do { DDRB &= ~0x1; } while(0)
#define d0_SetDigitalOutput() do { DDRB |= 0x1; } while(0)
#define d0_SetPullUp() do { PORTB |= 0x1; } while(0)
#define d0_ResetPullUp() do { PORTB &= ~0x1; } while(0)

//get/set d1 aliases
#define d1_SetHigh() do { PORTB |= 0x2; } while(0)
#define d1_SetLow() do { PORTB &= ~0x2; } while(0)
#define d1_Toggle() do { PINB |= 0x2; } while(0)
#define d1_GetValue() (PINB & (0x1 << 1))
#define d1_SetDigitalInput() do { DDRB &= ~0x2; } while(0)
#define d1_SetDigitalOutput() do { DDRB |= 0x2; } while(0)
#define d1_SetPullUp() do { PORTB |= 0x2; } while(0)
#define d1_ResetPullUp() do { PORTB &= ~0x2; } while(0)

//get/set d2 aliases
#define d2_SetHigh() do { PORTB |= 0x4; } while(0)
#define d2_SetLow() do { PORTB &= ~0x4; } while(0)
#define d2_Toggle() do { PINB |= 0x4; } while(0)
#define d2_GetValue() (PINB & (0x1 << 2))
#define d2_SetDigitalInput() do { DDRB &= ~0x4; } while(0)
#define d2_SetDigitalOutput() do { DDRB |= 0x4; } while(0)
#define d2_SetPullUp() do { PORTB |= 0x4; } while(0)
#define d2_ResetPullUp() do { PORTB &= ~0x4; } while(0)

//get/set d3 aliases
#define d3_SetHigh() do { PORTB |= 0x8; } while(0)
#define d3_SetLow() do { PORTB &= ~0x8; } while(0)
#define d3_Toggle() do { PINB |= 0x8; } while(0)
#define d3_GetValue() (PINB & (0x1 << 3))
#define d3_SetDigitalInput() do { DDRB &= ~0x8; } while(0)
#define d3_SetDigitalOutput() do { DDRB |= 0x8; } while(0)
#define d3_SetPullUp() do { PORTB |= 0x8; } while(0)
#define d3_ResetPullUp() do { PORTB &= ~0x8; } while(0)

//get/set enable aliases
#define enable_SetHigh() do { PORTB |= 0x10; } while(0)
#define enable_SetLow() do { PORTB &= ~0x10; } while(0)
#define enable_Toggle() do { PINB |= 0x10; } while(0)
#define enable_GetValue() (PINB & (0x1 << 4))
#define enable_SetDigitalInput() do { DDRB &= ~0x10; } while(0)
#define enable_SetDigitalOutput() do { DDRB |= 0x10; } while(0)
#define enable_SetPullUp() do { PORTB |= 0x10; } while(0)
#define enable_ResetPullUp() do { PORTB &= ~0x10; } while(0)

//get/set RS aliases
#define RS_SetHigh() do { PORTB |= 0x20; } while(0)
#define RS_SetLow() do { PORTB &= ~0x20; } while(0)
#define RS_Toggle() do { PINB |= 0x20; } while(0)
#define RS_GetValue() (PINB & (0x1 << 5))
#define RS_SetDigitalInput() do { DDRB &= ~0x20; } while(0)
#define RS_SetDigitalOutput() do { DDRB |= 0x20; } while(0)
#define RS_SetPullUp() do { PORTB |= 0x20; } while(0)
#define RS_ResetPullUp() do { PORTB &= ~0x20; } while(0)

//get/set LED1 aliases
#define LED1_SetHigh() do { PORTD |= 0x4; } while(0)
#define LED1_SetLow() do { PORTD &= ~0x4; } while(0)
#define LED1_Toggle() do { PIND |= 0x4; } while(0)
#define LED1_GetValue() (PIND & (0x1 << 2))
#define LED1_SetDigitalInput() do { DDRD &= ~0x4; } while(0)
#define LED1_SetDigitalOutput() do { DDRD |= 0x4; } while(0)
#define LED1_SetPullUp() do { PORTD |= 0x4; } while(0)
#define LED1_ResetPullUp() do { PORTD &= ~0x4; } while(0)
///@}

/**
 * @ingroup  pinsdriver
 * @brief Initializes the General Purpose Input/Output (GPIO), peripheral I/O pins and related registers.
 * @param None.
 * @return None.
 */
void PIN_MANAGER_Initialize();

#endif /* PINS_H_INCLUDED */
