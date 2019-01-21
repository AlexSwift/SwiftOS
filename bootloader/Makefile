#********************************************************
#				SwiftOS buildchain V0.3
#********************************************************

all: bootloader.bootstrap bootloader.stage1 bootloader.build clean

.PHONY: all test

bootloader.bootstrap:
	$(MAKE) -C ./bootstrap/ build

bootloader.stage1:
	$(MAKE) -C ./stage1/ build
	
bootloader.build: bootloader.bootstrap bootloader.stage1

clean:
	$(MAKE) -C ./stage1/ clean
	$(MAKE) -C ./stage2/ clean
