#********************************************************)
#				SwiftOS buildchain V0.3					   )
#********************************************************)

all: clean test build

.PHONY: all

ASMFILES = stage1
TARGETDIR = bin
TARGET = stage1.bin
OBJDIR = obj
ASMDIR = asm
DEFINES +=
INCLUDES +=
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
	
$(TARGET):
	@echo Linking swiftos.bootloader.stage1
	@echo $^
	$(SILENT) mkdir -p $(TARGETDIR)
	$(SILENT) $(LINKCMD) -o $(TARGETDIR)/$(TARGET) $(ASMOBJECTS)
	$(SILENT) chmod a+rw $(TARGETDIR)/$@
	
build: $(ASMFILES) $(TARGET)

clean:
	$(info Cleaning Stage1 )
	$(info $(BIND) )
	#rm -r $(BIND)/*