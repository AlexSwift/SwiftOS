#include <libk/stdlib.h>
#include <libk/stdio.h>

#include "bootstrap/multiboot.h"

#include "terminal.h"
#include "pic.h"
#include "interupts.h"

#include "devices/keyboard.h"
#include "devices/timer.h"

void kernel_main(unsigned long magic){//, unsigned long addr) {

	//multiboot_info_t *mbi;

	terminal_initialize();

	if (magic != MULTIBOOT_BOOTLOADER_MAGIC){
		printf("Error! Magic number invalid: %d\n", magic);
		abort();
	}
	
	terminal_setcolor( vga_entry_color(VGA_COLOR_LIGHT_GREY, VGA_COLOR_BLACK) );                         
	terminal_writestring("[Kernel] Booted into kernel                                                 [");
	terminal_setcolor( vga_entry_color(VGA_COLOR_LIGHT_GREEN, VGA_COLOR_BLACK) );
	terminal_writestring("OK");
	terminal_setcolor( vga_entry_color(VGA_COLOR_LIGHT_GREY, VGA_COLOR_BLACK) );
	terminal_writestring("]");

	pic_remap( 0x20, 0x28 );
	interupts_init();

	// Setup devices
	keyboard_initialize();
	timer_initialize();

	abort();

}