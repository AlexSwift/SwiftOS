#include <libc/stdio.h>
#include <kernel/terminal.h>

int puts(const char* string) {
	//terminal_writestring(string);
	return printf("%s\n", (char *)string);
}