#include "a20.h"
#include "registers.h"
#include "io.h"
#include "tty.h"
#include "util.h"

void a20_enable(){

	PRINT( "Attempting to enable A20 memory line!\n" );

	outb( (inb( 0x92 )|0x02)&0xFE , 0x92 );

	registers_t regs;
	initregs( &regs );

	regs.ax = 0x2401;
	intcall( 0x0F, &regs, &regs );

	if(regs.ah==0x86){
		ERROR( "A20 memory line not supported!\n" );
		return;
	}else if(regs.ah==0x01){
		ERROR( "A20 memory line in secure mode!\n" );
		return;
	}

	PRINT( "A20 Memory lane active!\n" );

}