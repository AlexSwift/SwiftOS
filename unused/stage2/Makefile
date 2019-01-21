#********************************************************)
#				SwiftOS buildchain V0.3					 )
#********************************************************)

all: clean test

.PHONY: all

ASMFILES = entry \

CPPFILES = main.cpp \
	terminal.cpp

TARGETDIR = bin
TARGET = stage2.bin
SRCDIR = src
OBJDIR = obj
ASMDIR = asm
DEFINES +=
INCLUDES += -I./include/ -I../../../cross-compiler/lib/gcc/i686-elf/9.0.0/include
FORCE_INCLUDE +=
ALL_CXXFLAGS += $(DEFINES) $(INCLUDES) -ffreestanding -O2 -Wall -Wextra -fno-exceptions -fno-rtti
ALL_CFLAGS += $(ALL_CPPFLAGS) -m32 -O2
ASMOBJECTS +=
CPPOBJECTS +=
LIBS +=
LDDEPS +=
ALL_LDFLAGS += -m32 -s
LINKCMD = i686-elf-ld -Ttext 0x0000 --oformat binary 

$(ASMFILES):
	$(info Compiling $(ASMDIR)/$@.asm into $(OBJDIR)/$@.o )
	nasm $(ASMDIR)/$@.asm -f elf -o $(OBJDIR)/$@.o
	$(SILENT)chmod a+rw $(OBJDIR)/$@.o
	$(eval  ASMOBJECTS += $(OBJDIR)/$@.o )

$(CPPFILES):
	$(info Compiling $(SRCDIR)/$@ into $(OBJDIR)/$*.o )
	$(SILENT) mkdir -p $(OBJDIR)
	i686-elf-g++ -c $(SRCDIR)/$@ -o $(OBJDIR)/$*.o $(ALL_CXXFLAGS)
	$(SILENT) chmod a+rw $(OBJDIR)/$*.o
	$(eval  CPPOBJECTS += $(OBJDIR)/$*.o )
	
$(TARGET):
	@echo Linking swiftos.bootloader.stage2
	@echo $^
	$(SILENT) mkdir -p $(TARGETDIR)
	$(SILENT) $(LINKCMD) -o $(TARGETDIR)/$(TARGET) $(ASMOBJECTS) $(CPPOBJECTS)
	$(SILENT) chmod a+rw $(TARGETDIR)/$@
	
build: $(ASMFILES) $(CPPFILES) $(TARGET)


clean:
	$(info )
	$(info  Cleaning Stage2 )
	$(info )
	#rm -r $(OBJD)/*
	#rm -r $(BIND)/*
