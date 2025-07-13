/*
 * assemblyToC.h
 *
 * Created: 7/11/2025 5:52:08 PM
 *  Author: joao0
 */ 


#ifndef ASSEMBLYTOC_H_
#define ASSEMBLYTOC_H_
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

void assemblyLcdInit(void);

void assemblyLcdIntPrint(uint8_t value);

void assemblyLcdStrPrint(const char* s);

void assemblySYSTEM_Initialize(void);

void assemblyLcdPrintTest(void);

void assemblyLcdPrintHours(uint8_t value);

void assemblyLcdPrintMinutes(uint8_t value);

void assemblyLcdPrintSeconds(uint8_t value);

void getDigits(uint8_t value, uint8_t *digits);

void AssemblyLcdClear();

#ifdef __cplusplus
}
#endif



#endif /* ASSEMBLYTOC_H_ */