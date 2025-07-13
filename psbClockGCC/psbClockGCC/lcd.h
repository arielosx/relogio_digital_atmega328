/*
 * lcd.h
 *
 * Created: 7/10/2025 8:12:03 PM
 * Modified by: Joao Cerqueira
 * Based on LiquidCrystal.h from Arduino, LGPL.
 */ 

#ifndef LCD_H_
#define LCD_H_


#include <inttypes.h>

#include "pinWrite.h"
#include "timer.h"
#include "mcc_generated_files/system/pins.h"
#include "mcc_generated_files/system/system.h"
#include <avr/pgmspace.h>

// commands
#define LCD_CLEARDISPLAY 0x01
#define LCD_RETURNHOME 0x02
#define LCD_ENTRYMODESET 0x04
#define LCD_DISPLAYCONTROL 0x08
#define LCD_CURSORSHIFT 0x10
#define LCD_FUNCTIONSET 0x20
#define LCD_SETCGRAMADDR 0x40
#define LCD_SETDDRAMADDR 0x80

// flags for display entry mode
#define LCD_ENTRYRIGHT 0x00
#define LCD_ENTRYLEFT 0x02
#define LCD_ENTRYSHIFTINCREMENT 0x01
#define LCD_ENTRYSHIFTDECREMENT 0x00

// flags for display on/off control
#define LCD_DISPLAYON 0x04
#define LCD_DISPLAYOFF 0x00
#define LCD_CURSORON 0x02
#define LCD_CURSOROFF 0x00
#define LCD_BLINKON 0x01
#define LCD_BLINKOFF 0x00

// flags for display/cursor shift
#define LCD_DISPLAYMOVE 0x08
#define LCD_CURSORMOVE 0x00
#define LCD_MOVERIGHT 0x04
#define LCD_MOVELEFT 0x00

// flags for function set
#define LCD_8BITMODE 0x10
#define LCD_4BITMODE 0x00
#define LCD_2LINE 0x08
#define LCD_1LINE 0x00
#define LCD_5x10DOTS 0x04
#define LCD_5x8DOTS 0x00



class LCD{
	public:
	LCD();

	void init();
	
	void begin(uint8_t cols, uint8_t rows, uint8_t charsize = LCD_5x8DOTS);
	
	void command(uint8_t value);
	
	void display();
	
	uint8_t write(uint8_t value);
	
	uint8_t write(const char* s);
	
	void clear();
	

	private:
	void send(uint8_t, uint8_t);
	
	void write4bits(uint8_t);
	
	void pulseEnable(void);
	
	
	
	
	
	Pin _rs_pin; // LOW: command. HIGH: character.
	Pin _enable_pin; // activated by a HIGH pulse.
	Pin _data_pins[4];

	uint8_t _displayfunction;
	uint8_t _displaycontrol;
	uint8_t _displaymode;

	uint8_t _initialized;

	uint8_t _numlines;
	uint8_t _row_offsets[4];
};



#endif /* LCD_H_ */