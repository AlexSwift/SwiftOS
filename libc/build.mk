# CFLAGS for module 'bar'
CFLAGS_libc := -std=gnu99 -ffreestanding -fno-builtin -nostdlib -nostartfiles -Wall -Wextra -Ilibc/includes/ -Ilibc/ -D__is_libc

# Executable to build in module 'bar'
libc_ARCHIVE := libc

libc_SOURCES := stdlib/abort.c \
	stdio/putchar.c \
	stdio/printf.c \
	stdio/puts.c \
	string/strlen.c \
	string/memcpy.c