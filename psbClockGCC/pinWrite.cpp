/*
 * pinWrite.cpp
 *
 * Created: 7/10/2025 11:19:58 PM
 *  Author: Joao Cerqueira 
 * based on arduino.h
 */ 

#include "pinWrite.h"

void pinWrite(Pin pin, uint8_t val)
{
	if (val == 0) {
		PORTB &= ~pin;
		} else {
		PORTB |= pin;
	}
}
