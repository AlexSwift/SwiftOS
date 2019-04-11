#include <stdint.h>

#include "interupts.h"
#include "terminal.h"
#include "io.h"
#include "pic.h"

#include "devices/timer.h"
#include "devices/keyboard.h"

#include <libk/stdio.h>
#include <libk/stdlib.h>
#include <libk/string.h>

idt_entry_t IDT[IRQ_MAX];
unsigned long idt_ptr[2];

unsigned long idt_common_handler( unsigned long interupt, unsigned long error, unsigned long eip ){

	switch (interupt){
		case 0x01:
			printf("[Kernel] Test Int! %d\n", error );
			break;
		case 0x0D:{
			unsigned long cs = (unsigned long)(*(&eip + 1));
			printf("[Kernel] General Protection Fault! %d %d %d\n", eip, error, cs );
			abort();
			break;
		};
		case 0x20:
			timer_interupt_handler();
			break;
		case 0x21:
			keyboard_interupt_handler();
			break;
		case 0x2C:
			printf("[Kernel] Received Ps/2 mouse! %d\n", error );
			break;
		default:
			printf("[Kernel] Unregistered interupt! %d\n", interupt );
	}

	if (( 0x20<=interupt ) && (interupt<0x30))
		pic_sendEOI( interupt - 0x20 );

	return eip;
}

void interupts_init(void){

	unsigned long irq_address;
	unsigned long idt_address;

	idt_entry_t dummy;
	dummy.selector = 0x08; /* KERNEL_CODE_SEGMENT_OFFSET */
	dummy.zero = 0;
	dummy.type_attr = 0x8E; //0x8e; /* INTERRUPT_GATE */ //1 11 0 1110
	for (int i = 0x00; i<0xFF; i++){

		irq_address = (unsigned long)(*(&irq_list + i )) ;
		dummy.offset_lowerbits = irq_address & 0xffff;
		dummy.offset_higherbits = (irq_address & 0xffff0000) >> 16;
		memcpy( (void *)( &IDT[i] ), (void *)&dummy , sizeof( idt_entry_t ) );

	}

	/* fill the IDT descriptor */
	idt_address = (unsigned long)IDT ;
	idt_ptr[0] = (sizeof (idt_entry_t) * 256) + ((idt_address & 0xffff) << 16);
	idt_ptr[1] = idt_address >> 16 ;

	idt_load(idt_ptr);
}