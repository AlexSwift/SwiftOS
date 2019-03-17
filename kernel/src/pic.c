#include <libk/stdio.h>
#include "io.h"
#include "pic.h"

#define IO_PIC_MASTER	0x20
#define IO_PIC_SLAVE	0xA0

#define IO_PIC_MASTER_COMMAND	IO_PIC_MASTER
#define IO_PIC_MASTER_DATA		(IO_PIC_MASTER+1)
#define IO_PIC_SLAVE_COMMAND	IO_PIC_SLAVE
#define IO_PIC_SLAVE_DATA		(IO_PIC_SLAVE+1)

#define PIC_EOI	0x20

/* reinitialize the PIC controllers, giving them specified vector offsets
   rather than 8h and 70h, as configured by default */
 
#define ICW1_ICW4	0x01		/* ICW4 (not) needed */
#define ICW1_SINGLE	0x02		/* Single (cascade) mode */
#define ICW1_INTERVAL4	0x04		/* Call address interval 4 (8) */
#define ICW1_LEVEL	0x08		/* Level triggered (edge) mode */
#define ICW1_INIT	0x10		/* Initialization - required! */
 
#define ICW4_8086	0x01		/* 8086/88 (MCS-80/85) mode */
#define ICW4_AUTO	0x02		/* Auto (normal) EOI */
#define ICW4_BUF_SLAVE	0x08		/* Buffered mode/slave */
#define ICW4_BUF_MASTER	0x0C		/* Buffered mode/master */
#define ICW4_SFNM	0x10		/* Special fully nested (not) */

void pic_sendEOI(unsigned char irq){
	if (irq >= 8)
		outb(PIC_EOI,IO_PIC_SLAVE_COMMAND);
	outb(PIC_EOI,IO_PIC_MASTER_COMMAND);
}

void pic_remap( int pci_master_offset, int pci_slave_offset )
{
	puts("[Kernel] PCI Remapping interupt offsets");

	unsigned char a1, a2;
 
	a1 = inb(IO_PIC_MASTER_DATA);                        // save masks
	a2 = inb(IO_PIC_SLAVE_DATA);
 
	outb(ICW1_INIT | ICW1_ICW4, IO_PIC_MASTER_COMMAND);  // starts the initialization sequence (in cascade mode)
	io_wait();
	outb(ICW1_INIT | ICW1_ICW4, IO_PIC_SLAVE_COMMAND);
	io_wait();
	outb(pci_master_offset, IO_PIC_MASTER_DATA);                 // ICW2: Master PIC vector offset
	io_wait();
	outb(pci_slave_offset, IO_PIC_SLAVE_DATA);                 // ICW2: Slave PIC vector offset
	io_wait();
	outb(4, IO_PIC_MASTER_DATA);                       // ICW3: tell Master PIC that there is a slave PIC at IRQ2 (0000 0100)
	io_wait();
	outb(2, IO_PIC_SLAVE_DATA);                       // ICW3: tell Slave PIC its cascade identity (0000 0010)
 	io_wait();

	outb(ICW4_8086, IO_PIC_MASTER_DATA);
	io_wait();
	outb(ICW4_8086, IO_PIC_SLAVE_DATA);
	io_wait();
 
	outb(a1, IO_PIC_MASTER_DATA);   // restore saved masks.
	io_wait();
	outb(a2, IO_PIC_SLAVE_DATA);
	io_wait();

	puts("[Kernel] PCI Remapped");
}