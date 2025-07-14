/*
 * timer.h
 *
 * Created: 7/10/2025 10:40:23 PM
 *  Author: joao0
 */ 


#ifndef TIMER_H_
#define TIMER_H_
#include <inttypes.h>
#include "mcc_generated_files/system/pins.h"

extern uint16_t volatile timer_us;

#include <inttypes.h>

void delayMicroseconds(uint16_t us);


#endif /* TIMER_H_ */