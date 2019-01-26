# CFLAGS for module 'bar'
CFLAGS_kernel :=
LDFLAGS_kernel := -Ttext 0x0000 --oformat binary 

# Executable to build in module 'bar'
kernel_PROGRAM := kernel

# Libraries that the executable depends on:
kernel_LIBRARIES :=

# Sources for the executable 'bar' (without headers)
kernel_SOURCESASM := main.asm
kernel_INCLUDEASM := -Iconfig/ -Ikernel/src/
