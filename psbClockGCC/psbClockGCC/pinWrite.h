/*
 * pinWrite.h
 *
 * Created: 7/10/2025 11:20:09 PM
 *  Author: Joao Cerqueira
 * based on arduino
 */ 


#ifndef PINWRITE_H_
#define PINWRITE_H_

#ifdef __cplusplus
extern "C" {
#endif

#include <avr/io.h>

enum Pin
{
	PinPB0 = 1 << 0,
	PinPB1 = 1 << 1,
	PinPB2 = 1 << 2,
	PinPB3 = 1 << 3,
	PinPB4 = 1 << 4,
	PinPB5 = 1 << 5,
};

void pinWrite(Pin pin, uint8_t val);


#ifdef __cplusplus
}
#endif

#endif /* PINWRITE_H_ */