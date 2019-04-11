#ifndef _MEMORY_H
#define _MEMORY_H

#include <stdint.h>
#include <stddef.h>

#define MEMORY_MAX_ENTRIES 15

enum memory_types {
	MEMORY_TYPE_FREE = 0x0001,
	MEMORY_TYPE_RESERVED = 0x0002,
	MEMORY_TYPE_RECLAIMABLE = 0x0003,
};

typedef struct memory_map_entry {
	uint64_t base;
	uint64_t length;
	uint32_t type;
} memory_map_entry_t;

typedef struct memory_e820_entry {
	union {
		struct {
			uint64_t base;
			uint64_t length;
			uint32_t type;
			uint32_t extended;
		};
		struct {
			uint32_t baselow;
			uint32_t basehigh;
			uint32_t lengthlow;
			uint32_t lengthhigh;
		};
	};
} memory_e820_entry_t;

void memory_initialize( );

void memory_insert( int8_t pos, memory_map_entry_t * entry );
void memory_delete( int8_t pos );

void memory_map_get( );
void memory_map_print( );
void memory_map_validate( );

void memory_print_free( );
void memory_e820( );

memory_map_entry_t * memory_lowest( uint32_t base );
memory_map_entry_t * memory_max( );

uint8_t memory_map_count;

#endif