#ifndef _DISK_H
#define _DISK_H

#include <stdint.h>
#include <stdbool.h>

typedef struct disk_access_packet {
	uint8_t size;
	uint8_t zero;
	uint16_t count;
	uint16_t offset;
	uint16_t segment;
	uint64_t lba;

} disk_access_packet_t;

void disk_loaddata( uint8_t drive, disk_access_packet_t *packet );
void disk_loaddata_chs( uint8_t drive, disk_access_packet_t *packet );
bool disk_loaddata_lba( uint8_t drive, disk_access_packet_t *packet );

#endif