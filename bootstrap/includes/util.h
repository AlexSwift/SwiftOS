#ifndef _UTIL_H
#define _UTIL_H

#include <stdarg.h>

#define _DEBUG false

#define DEBUG(fmt, ...) \
	do { \
		if (_DEBUG) {\
			printf( "[DEBUG] " ); \
			printf( fmt, ## __VA_ARGS___ ); \
		}; \
	}while (0)

#define PRINT(fmt, ...) \
	do { \
		printf( "[Bootstrap] " ); \
		printf( fmt, ## __VA_ARGS__ ); \
	} while (0)

#define INFO(fmt, ...) \
	do { \
		printf( "[INFO] " ); \
		printf( fmt, ## __VA_ARGS__ ); \
	} while (0)

#define ERROR(fmt, ...) \
	do { \
		printf( "[ERROR] " ); \
		printf( fmt, ## __VA_ARGS__ ); \
		while (1){}; \
	} while (0)

#endif