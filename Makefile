#********************************************************
#				SwiftOS buildchain V0.4
#********************************************************

global: BIND OBJD BOOT

MAKE = make
BIND = bin
OBJD = obj
ROOT = iso

all:	build

# Build the Bootloader
swiftos.mkimg:
	dd if=/dev/zero of=bin/bootloader.img bs=1024 count=1440

swiftos.buildbootloader:
	$(MAKE) -C ./bootloader/ bootloader.build

swiftos.writebootloader:
	dd if=bootloader/bootstrap/bin/bootstrap.bin of=bin/bootloader.img obs=2048 seek=0 count=1 conv=notrunc
	#dd if=bootloader/stage1/bin/stage1.bin of=bin/bootloader.img obs=2048 seek=1 count=1 conv=notrunc
	#dd if=bootloader/stage2/bin/stage2.bin of=bin/bootloader.img obs=2048 seek=1 count=4 conv=notrunc
	cp $(BIND)/bootloader.img  $(ROOT)/bootloader.img
	
swiftos.mkiosfs:
	mkisofs  -r -J -V 'swiftOS' -input-charset utf8 -no-emul-boot -boot-load-size 1 -boot-info-table -o swiftos.iso -b bootloader.img iso

swiftos.writeStages:
	dd if=bootloader/stage1/bin/stage1.bin of=swiftos.iso obs=2048 seek=1 count=6 conv=notrunc
	#dd if=bootloader/stage2/bin/stage2.bin of=swiftos.iso obs=2048 seek=2 count=4 conv=notrunc

build: swiftos.mkimg swiftos.buildbootloader swiftos.writebootloader swiftos.mkiosfs swiftos.writeStages

clean:
	$(MAKE) -C ./bootloader/ clean
	
