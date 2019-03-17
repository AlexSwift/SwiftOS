# CFLAGS for module 'bar'
CFLAGS_libk := -std=gnu11 -ffreestanding -Wall -Wextra -Ilibc/includes/ -Ilibc/ -D__is_libk

# Executable to build in module 'bar'
libk_ARCHIVE := libk

libk_SOURCES := $(libc_SOURCES)