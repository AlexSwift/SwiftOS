#include "bit.h"
#include "memory.h"
#include "registers.h"
#include "string.h"
#include "tty.h"
#include "util.h"

memory_map_entry_t memory_map_buffer[MEMORY_MAX_ENTRIES];
uint8_t memory_map_count;

void memory_initialize( ){

	memory_map_count = 0;
	memory_map_get();
}

void memory_map_get( ){

	memory_e820( );
	memory_map_validate( );
	memory_map_print( );

	memory_print_free( );

};

void memory_print_free( ){

	uint64_t freeMemory = 0;

	for ( uint8_t n=0; n<memory_map_count; n++ ){
		memory_map_entry_t * entry = &memory_map_buffer[n];
		if ( entry->type == MEMORY_TYPE_FREE ) freeMemory += entry->length;
	}

	INFO( "Amount of free memory: %lx Bytes\n", freeMemory );

};

void memory_map_print(){
	for(int i=0; i<memory_map_count;i++){
		memory_map_entry_t *entry = &memory_map_buffer[i];
		printf("base:%lx - length:%lx - type:%d\n",
			entry->base,
			entry->length,
			entry->type);
	}
}


void memory_addEntry( uint64_t base, uint64_t length, uint32_t type ){

	if( length==0 || type==0 )
		return;

	memory_map_entry_t entry;

	entry.base = base;
	entry.length = length;
	entry.type = type;

	memory_map_buffer[memory_map_count++] = entry;
}

void memory_insert( int8_t pos, memory_map_entry_t * entry ){

	if(memory_map_count+1==MEMORY_MAX_ENTRIES){
		ERROR( "Exceeded bounds of memory_map_buffer bounds!\n" );
		while(true){};
		return;
	};

	memmove( (void *)&memory_map_buffer[pos+1], (void *)&memory_map_buffer[pos], (memory_map_count-pos)*sizeof(memory_map_entry_t));
	memcpy( (void *)&memory_map_buffer[pos], (void *)entry, sizeof(memory_map_entry_t) );

	memory_map_count++;
}

void memory_swap( int8_t pos, int8_t pos2 ){

	if( pos == pos2) return;

	memory_map_entry_t temp = memory_map_buffer[pos];
	memory_map_buffer[pos] = memory_map_buffer[pos2];
	memory_map_buffer[pos2] = temp;

}

void memory_delete( int8_t pos ){

	memmove( (void *)&memory_map_buffer[pos], (void *)&memory_map_buffer[pos+1], (memory_map_count-pos)*sizeof(memory_map_entry_t));
	memset( (void *)&memory_map_buffer[memory_map_count], 0, sizeof(memory_map_entry_t) );
	memory_map_count--;

}

void memory_e820( ){

	INFO( "Attempting to get memory map!\n" );

	registers_t reg;
	memory_e820_entry_t buffer;

	initregs( &reg );

	reg.edi = (uint32_t)&buffer;
	reg.eax = 0xe820;
	reg.ebx = 0;
	reg.ecx = sizeof(registers_t);
	reg.edx = 0x534D4150;

	intcall( 0x15, &reg, &reg );

	if( bit_isSet( reg.eflags, REGISTERS_EFLAGS_CF ) || reg.eax != 0x534D4150 || reg.ebx == 0){
		ERROR("%s E820 Memory mapping not supported!\n", __PRETTY_FUNCTION__);
		return;
	}

	memory_addEntry( buffer.base , buffer.length, buffer.type );

	while(true){

		reg.edi = (uint32_t)&buffer;
		reg.eax = 0xe820;
		reg.ecx = 24;

		intcall( 0x15, &reg, &reg);

		if( bit_isSet( reg.eflags, REGISTERS_EFLAGS_CF ) || (reg.ecx == 0 ) || (reg.ebx == 0 ) ) break;

		if(reg.cl == 20){
			// Not Extended
		}else{
			// Extended
		};

		memory_addEntry( buffer.base , buffer.length, buffer.type );
	};
}


memory_map_entry_t * memory_lowest( uint32_t base ){

	memory_map_entry_t * ret = &memory_map_buffer[0];

	for( uint8_t n=0; n<memory_map_count; n++ ){

		memory_map_entry_t * entry = &memory_map_buffer[n];

		if( entry->base < base )
			continue;
		if ((entry->base - base) < (ret->base - base) ){
			ret = entry;
		}
	};

	return ret;
}

memory_map_entry_t * memory_max( ){

	memory_map_entry_t * ret = &memory_map_buffer[0];

	for( uint8_t n=0; n<memory_map_count; n++ ){
		memory_map_entry_t * entry = &memory_map_buffer[n];
		if( entry->base > ret->base ){
			ret = entry;
		}
	};

	return ret;
}

void memory_map_validate( ){

	uint32_t p = 0;
	size_t n = 0;
	size_t n_prime = 0;

	// Sort?
	/*
	memory_map_entry_t *lowest = memory_lowest( p );
	memory_swap( 0, (lowest - memory_map_buffer)/sizeof(memory_map_entry_t) );
	while(n++<memory_map_count){

	}*/

	// Add missing blocks
	while(true){

		memory_map_entry_t * max = memory_max( );
		memory_map_entry_t * entry = &memory_map_buffer[n_prime];

		// We have reached the end of our memory
		if( p == (max->base + max->length) ) break;

		// We have found a a block that starts where we end
		if( p==entry->base ){

			p += entry->length;
			n = n_prime;
			n_prime = 0;

			continue;
		};

		// The end of this block doesn't match with the start of another
		if( n_prime == memory_map_count){

			memory_map_entry_t entry_new;

			entry_new.base = p;
			entry_new.length = (memory_lowest( p )->base - p );
			entry_new.type = MEMORY_TYPE_RESERVED;

			memory_insert( n + 1, &entry_new );
			p += entry_new.length;
			n_prime = 0;
		}

		n_prime++;
	};

	// Merge consecutive types
	for(uint8_t n=0;n<memory_map_count;){

		memory_map_entry_t * curr = &memory_map_buffer[n];
		memory_map_entry_t * next = &memory_map_buffer[n+1];

		if ((curr->type == next->type)&&( curr->base+curr->length == next->base)){
			curr->length = next->length + next->base - curr->base;
			memory_delete(n+1);
			continue;
		}

		n++;
	}
}