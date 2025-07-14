/*
 * timer.cpp
 *
 * Created: 7/10/2025 10:32:35 PM
 *  Author: Joao Cerqueira
 */ 

#include "timer.h"


void delayMicroseconds(uint16_t us)
{
	while(timer_us < us){}
}
