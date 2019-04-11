#include <stddef.h>

#include "kernel.h"
#include "disk.h"
#include "oem.h"
#include "registers.h"

void kernel_load( uint8_t drive, const char *filename ){

	disk_access_packet_t packet;

	packet.lba = (uint64_t)oem_bi_PrimaryVolumeDescriptor;
	packet.count = 1;

	//.Offset:			dw	bootstrap.diskTransferBuffer	; Offset :0000 
	//.Segment:			dw	SWIFTOS_BOOTSTRAP_SEGMNT		; Segment 0200

	packet.segment = ds();
	packet.offset = 0;

	disk_loaddata( drive, &packet );

}