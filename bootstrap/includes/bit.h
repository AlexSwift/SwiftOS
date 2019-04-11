#ifndef _BIT_H
#define _BIT_H

#include <stdbool.h>
#include <stdint.h>

static inline bool bit_isSet( uint32_t data, uint32_t flag ){
	return ((data&flag) == flag);
}

#endif