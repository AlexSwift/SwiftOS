#include <libk/stdlib.h>
#include <libk/stdio.h>
#include "terminal.h"
#include "pic.h"
#include "interupts.h"

void kernel_main(void) {
	
	terminal_initialize();
	terminal_setcolor( vga_entry_color(VGA_COLOR_LIGHT_GREY, VGA_COLOR_BLACK) );                         
	terminal_writestring("[Kernel] Booted into kernel                                                 [");
	terminal_setcolor( vga_entry_color(VGA_COLOR_LIGHT_GREEN, VGA_COLOR_BLACK) );
	terminal_writestring("OK");
	terminal_setcolor( vga_entry_color(VGA_COLOR_LIGHT_GREY, VGA_COLOR_BLACK) );
	terminal_writestring("]");

	pic_remap( 0x20, 0x28 );
	interupts_init();

	abort();

}