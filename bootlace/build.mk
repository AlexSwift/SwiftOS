# CFLAGS for module 'bar'
CFLAGS_bootlace :=
LDFLAGS_bootlace := -Ttext 0x0000 --oformat binary 

# Executable to build in module 'bar'
bootlace_PROGRAM := bootlace

# Libraries that the executable depends on:
bootlace_LIBRARIES :=

# Sources for the executable 'bar' (without headers)
bootlace_SOURCESASM := main.asm
bootlace_INCLUDEASM := -Iconfig/ -Ibootlace/src/
