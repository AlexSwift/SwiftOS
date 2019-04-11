#include <stdbool.h>

#include "disk.h"
#include "bit.h"
#include "registers.h"

#pragma pack(push)
#pragma pack(4)

disk_access_packet_t disk_dap;

#pragma pack(pop)

bool disk_extended( ){

	registers_t regs;
	initregs( &regs );

	regs.ah = 0x41;
	regs.bx = 0x55aa;
	regs.dl = 0x80;

	intcall( 0x13, &regs, &regs );

	if( bit_isSet( regs.eflags, REGISTERS_EFLAGS_CF ) )
		return false;

	return true;
}

void disk_loaddata( uint8_t drive, disk_access_packet_t *packet ){

	if( disk_extended( ) ){
		disk_loaddata_lba( drive, packet );
	}else{
		disk_loaddata_chs( drive, packet );
	};

}

bool disk_loaddata_lba( uint8_t drive, disk_access_packet_t *packet ){

	registers_t regs;
	initregs( &regs );

	regs.esi = (uint32_t)packet;
	regs.ah = 0x42;
	regs.dl = drive;

	packet->size = sizeof(*packet);

	intcall( 0x13, &regs, &regs );

	if( bit_isSet( regs.eflags, REGISTERS_EFLAGS_CF ) )
		return false;

	return true;
}

void disk_loaddata_chs( uint8_t drive, disk_access_packet_t *packet ){

};