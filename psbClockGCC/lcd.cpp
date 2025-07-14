/*
 * PSB.cpp
 *
 * Created: 7/10/2025 7:57:48 PM
 * Modified by : Joao Cerqueira
 * Based on LiquidCrystal.h from Arduino, LGPL.
 */ 

#include "lcd.h"
#include "timer.h"
#include <avr/io.h>
#include <stdio.h>
#include <string.h>
#include <inttypes.h>


LCD::LCD()
{
}

void LCD::init()
{
	_rs_pin = PinPB5;
	_enable_pin = PinPB4;
	
	_data_pins[0] = PinPB0;
	_data_pins[1] = PinPB1;
	_data_pins[2] = PinPB2;
	_data_pins[3] = PinPB3;

	_displayfunction = LCD_4BITMODE | LCD_2LINE | LCD_5x8DOTS;

	begin(16, 2, LCD_5x8DOTS);
}

void LCD::begin(uint8_t cols, uint8_t lines, uint8_t dotsize) {
	
	_numlines = lines;
	_row_offsets[0] = 0x00;
	_row_offsets[1] = 0x40;
	delayMicroseconds(50000);
	// Now we pull both RS and R/W low to begin commands
	pinWrite(_rs_pin, 0);
	pinWrite(_enable_pin, 0);
	

	//put the LCD into 4 bit
	// this is according to the Hitachi HD44780 datasheet
	// page 45 figure 23
	write4bits(0x03);
	delayMicroseconds(4500); // wait min 4.1ms

	// second try
	write4bits(0x03);
	delayMicroseconds(4500); // wait min 4.1ms
		 
	// third go!
	write4bits(0x03);
	delayMicroseconds(150);

	// finally, set to 4-bit interface
	write4bits(0x02);

	
	
	// finally, set # lines, font size, etc.
	command(LCD_FUNCTIONSET | _displayfunction);

	// turn the display on with no cursor or blinking default
	_displaycontrol = LCD_DISPLAYON | LCD_CURSOROFF | LCD_BLINKOFF;
	display();

	// clear it off
	clear();

	// Initialize to default text direction (for romance languages)
	_displaymode = LCD_ENTRYLEFT | LCD_ENTRYSHIFTDECREMENT;
	// set the entry mode
	command(LCD_ENTRYMODESET | _displaymode);
}


void LCD::write4bits(uint8_t value) {
	for (int i = 0; i < 4; i++) {
		pinWrite(_data_pins[i], (value >> i) & 0x01);
	}
	pulseEnable();
}

void LCD::pulseEnable(void) {
	pinWrite(_enable_pin, 0);
	delayMicroseconds(1);
	pinWrite(_enable_pin, 1);
	delayMicroseconds(1);    // enable pulse must be >450 ns
	pinWrite(_enable_pin, 0);
	delayMicroseconds(100);   // commands need >37 us to settle
}


inline void LCD::command(uint8_t value) {
	send(value, 0);
}

uint8_t LCD::write(uint8_t value) {
	send(value + 48, 1);
	return 1; // assume success
}

uint8_t LCD::write(const char* s)
{
	while(*s)
	{
		send(*s, 1);
		s++;
	}
	return 1;
}


void LCD::send(uint8_t value, uint8_t mode) {
	pinWrite(_rs_pin, mode);
	write4bits(value>>4);
	write4bits(value);
}

void LCD::display() {
	_displaycontrol |= LCD_DISPLAYON;
	command(LCD_DISPLAYCONTROL | _displaycontrol);
}

void LCD::clear()
{
	command(LCD_CLEARDISPLAY);  // clear display, set cursor position to zero
	delayMicroseconds(2000);  // this command takes a long time!
}