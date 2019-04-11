# CFLAGS for module 'bar'

CFLAGS_bootstrap := -std=gnu99 -m16 -Os -ffreestanding -Wall -Wextra -Ibootstrap/includes/
LDFLAGS_bootstrap := -e boot_entry -pie -T bootstrap/linker.ld -Wl,--oformat=binary -lgcc 

# Executable to build in module 'bar'
bootstrap_PROGRAM := bootstrap

# Libraries that the executable depends on:
bootstrap_LIBRARIES :=

# Sources for the executable 'bar' (without headers)
bootstrap_SOURCESASM := asm/bootsector.asm
bootstrap_INCLUDEASM := -Iconfig/ -Ibootstrap/includes/ -Ibootstrap/src/

bootstrap_SOURCES := main.c \
	string.c \
	registers.c \
	memory.c \
	tty.c \
	a20.c \
	kernel.c \
	disk.c

