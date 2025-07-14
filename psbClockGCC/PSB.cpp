/*
 * assemblyToC.cpp
 *
 * Created: 7/11/2025 5:51:50 PM
 *  Author: joao0
 */ 

#include "lcd.h"
#include "mcc_generated_files/system/system.h"
#include "mcc_generated_files/system/src/pins.c"
#include "PSB.h"


uint16_t volatile timer_us = 0;
static LCD lcd;

extern "C" void assemblyLcdInit(void)
{
	lcd.init();
}

extern "C" void assemblyLcdIntPrint(uint8_t value)
{
	lcd.write(value);
}

extern "C" void assemblyLcdStrPrint(const char* s)
{
	lcd.write(s);
}

extern "C" void assemblySYSTEM_Initialize(void)
{
	CPU_Initialize();
	PIN_MANAGER_Initialize();
	CPUINT_Initialize();
	LcdTimer_Initialize();
	
}

extern "C" void assemblyLcdPrintTest(void)
{
	lcd.write("TEST");
	
}

extern "C" void assemblyLcdPrintHours(uint8_t value)
{
	lcd.write("    ");
	uint8_t digits[2] = {0, 0};	
	getDigits(value, &digits[0]);
	lcd.write(digits[1]);
	lcd.write(digits[0]);
	lcd.write(":");
	
}

extern "C" void assemblyLcdPrintMinutes(uint8_t value)
{
	uint8_t digits[2] = {0, 0};
	getDigits(value, &digits[0]);
	lcd.write(digits[1]);
	lcd.write(digits[0]);
	lcd.write(":");
}

extern "C" void assemblyLcdPrintSeconds(uint8_t value)
{
	uint8_t digits[2] = {0, 0};
	getDigits(value, &digits[0]);
	lcd.write(digits[1]);
	lcd.write(digits[0]);
	
}

void getDigits(uint8_t value, uint8_t *digits)
{
	uint8_t resultado = value/10; 
	digits[1] = resultado;
	resultado = value - resultado*10;
	digits[0] = resultado;
}

extern "C" void AssemblyLcdClear()
{
	lcd.clear();
}



