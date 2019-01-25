# CFLAGS for module 'bar'
CFLAGS_bootstrap :=
LDFLAGS_bootstrap := -Ttext 0x0000 --oformat binary

# Executable to build in module 'bar'
bootstrap_PROGRAM := bootstrap

# Libraries that the executable depends on:
bootstrap_LIBRARIES :=

# Sources for the executable 'bar' (without headers)
bootstrap_SOURCESASM := main.asm
bootstrap_INCLUDEASM := -Iconfig/ -Ibootstrap/src/
