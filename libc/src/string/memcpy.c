#include <stddef.h>

void memcpy ( void* __restrict destination, const void* __restrict source, size_t length ){

	unsigned char* dst = (unsigned char*) destination;
	const unsigned char* src = (const unsigned char*) source;

	for (size_t i=0; i<length; i++){
		dst[i] = src[i];
	}

}