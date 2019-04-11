#include <stddef.h>
#include "string.h"
#include "registers.h"

void *memset( void *dest, int val, size_t len ){
	
	unsigned char *ptr = (unsigned char*) dest;

	while(len-- > 0)
		*ptr++ = val;
	return dest;
}

void memcpy( void* __restrict destination, const void* __restrict source, size_t length ){

	uint8_t * dst = (uint8_t *) destination;
	const uint8_t * src = (const uint8_t *) source;

	for (size_t i=0; i<length; i++){
		if ((dst - src) >= length){
			dst[i] = src[i];
		}else{
			dst[length-i] = src[length-i];
		}
	}
}

void memmove(void * __restrict destination, const void * __restrict source, size_t len){
	
	uint8_t * dst = (uint8_t *) destination;
	uint8_t * src = (uint8_t *) source;

	if (dst < src)
		while (len--) *dst++ = *src++;
	else{
		uint8_t * lasts = src + (len-1);
		uint8_t * lastd = dst + (len-1);
		while (len--) *lastd-- = *lasts--;
    }
	//return dst;
}