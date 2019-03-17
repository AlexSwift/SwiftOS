# CFLAGS for module 'bar'
CFLAGS_kernel := -std=gnu99 -ffreestanding -Wall -Wextra -Ikernel/includes/
LDFLAGS_kernel := -T kernel/linker.ld --oformat binary 

# Executable to build in module 'bar'
kernel_PROGRAM := kernel

# Libraries that the executable depends on:
kernel_LIBRARIES := libk

# Sources for the executable 'bar' (without headers)
kernel_SOURCESASM := entry.asm \
	interupts.asm
kernel_INCLUDEASM := -Iconfig/ -Ikernel/src/

kernel_SOURCES := main.c \
	terminal.c \
	pic.c \
	interupts.c \
	devices/keyboard.c
