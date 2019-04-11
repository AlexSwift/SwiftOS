#include <stddef.h>

void memcpy ( void* __restrict destination, const void* __restrict source, size_t length ){

	unsigned char* dst = (unsigned char*) destination;
	const unsigned char* src = (const unsigned char*) source;

	if ((src + length)<dst){
		for (size_t i=0; i<length; i++){
			dst[i] = src[i];
		}
	}else{
		for (size_t i=0; i<length; i++){
			dst[length-i] = src[length-i];
		}
	}

}