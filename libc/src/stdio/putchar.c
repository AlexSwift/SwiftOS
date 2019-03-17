#include <stdio.h>
 
#if defined(__is_libk)
#include <kernel/terminal.h>
#endif
 
int putchar(char c) {
#if defined(__is_libk)
	terminal_putchar(c);
#else
	// TODO: Implement stdio and the write system call.
#endif
	return (int)c;
}