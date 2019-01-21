/***************************************************************************
;
;						swiftOS v0.3: terminal.h
;			with thanks to osdev.org and it's contributors
;***************************************************************************/

#include "terminal.h"
#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>
//#include <string.h>

/****************************************************
;		Definitions of parameters
;***************************************************/

extern "C" void video_copy( uint32_t, uint32_t, uint32_t, uint16_t * ); //uint32_t, uint32_t, uint16_t * , uint32_t

uint8_t terminal_row;
uint8_t terminal_column;
uint8_t terminal_color;
uint16_t* terminal_buffer;

static const size_t VGA_WIDTH = 80;
static const size_t VGA_HEIGHT = 25;

const unsigned char str[19] = "Printing from CPP!";
uint16_t buff[18] = {0};

static inline uint16_t vga_entry(unsigned char uc, uint8_t color) 
{
	return (uint16_t) uc | (uint16_t) color << 8;
}

static inline uint8_t vga_entry_color(enum vga_color fg, enum vga_color bg) 
{
	return fg | bg << 4;
}

void terminal_init() {
	terminal_color = vga_entry_color(VGA_COLOR_LIGHT_GREY, VGA_COLOR_BLACK);
	for (int i=0; i<18; i++ ) {
		
		buff[i] = vga_entry( str[i], terminal_color);
	}
	
	//terminal_row = (uint8_t)&( video
	
	video_copy( 0, 20, 18, buff );	//0, 0 , buff , 39
	
	return;
}
