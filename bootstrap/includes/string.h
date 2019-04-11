#ifndef _STRING_H
#define _STRING_H

void * memset( void *dest, int val, size_t len );
void memcpy( void* __restrict destination, const void* __restrict source, size_t length );
void memmove(void * __restrict dest, const void * __restrict src, size_t len);

#endif