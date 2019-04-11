;***************************************************************************
;
;				swiftOS v0.5: BootStrap
;			with thanks to osdev.org and it's contributors
;***************************************************************************

; // TODO: Move this to the Makefile so we can build different bootloaders
;          for different file systems more efficiently. Long story short:
;          we either know the file system (yay for stage 1 and 1.5) or 
;          we don't, and we can just store sector offsets in a predefined
;          offset from begining of disk.
%define SWIFTOS_OEM_ISO

;****************************************************
;		Definitions of parameters
;****************************************************

section .bootsector
bits		16

;%include "defines.asm"

global boot_drive
global boot_entry

extern __stack_start
extern c_main

;****************************************************
;		Trampoline to our main loader
;****************************************************

boot_entry:
jmp 0x0000:boot_main

;****************************************************
;		Allign and setup OEM block
;****************************************************

%ifdef SWIFTOS_OEM_ISO

	times 08h-($-$$) db 0 ; Allign to 8 bytes

	global oem_bi_PrimaryVolumeDescriptor
	global oem_bi_BootFileLocation
	global oem_bi_BootFileLength
	global oem_bi_Checksum
	global oem_bi_Reserved

	oem_bi_PrimaryVolumeDescriptor:	DD  1    ; LBA of the Primary Volume Descriptor
	oem_bi_BootFileLocation:		DD  1    ; LBA of the Boot File
	oem_bi_BootFileLength:			DD  1    ; Length of the boot file in bytes
	oem_bi_Checksum:				DD  1    ; 32 bit checksum
	oem_bi_Reserved:				DB  40   ; Reserved 'for future standardization'
	
	times 40h-($-$$) db 0 ; Pad till end of predefined size
 
%elif SWIFTOS_OEM_FAT12 

	times 08h-($-$$) db 0 ; Allign to 8 bytes

	bootstrap.OEM:
	.bpbBytesPerSector:  		DW 512
	.bpbSectorsPerCluster: 		DB 1
	.bpbReservedSectors: 		DW 1
	.bpbNumberOfFATs: 	    	DB 2
	.bpbRootEntries: 	    	DW 224
	.bpbTotalSectors: 	    	DW 2880
	.bpbMedia: 	            	DB 0xF0
	.bpbSectorsPerFAT: 	    	DW 9
	.bpbSectorsPerTrack: 		DW 18
	.bpbHeadsPerCylinder: 		DW 2
	.bpbHiddenSectors: 	    	DD 0
	.bpbTotalSectorsBig:     	DD 0
	.bsDriveNumber: 	        DB 0
	.bsUnused: 	           		DB 0
	.bsExtBootSignature: 		DB 0x29
	.bsSerialNumber:	        DD 0xa0a1a2a3
	.bsVolumeLabel: 	        DB "SWIFT OS   "
	.bsFileSystem: 	        	DB "FAT12   "
	
	times 40h-($-$$) db 0 ; Pad till end of predefined size
	
%else

	%error "SWIFTOS_OEM_* not defined for any particular file system"
	
%endif

;****************************************************
;		Data
;****************************************************

boot_drive:		db 0

;****************************************************
;		Include Stage1 Libraries
;****************************************************	

;%include "bootsector/disk.asm"
;%include "bootsector/print_string.asm"

;****************************************************
;		Main Loader
;****************************************************

boot_main:

	; Setup Registers
	mov ax, cs
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax

	mov ax, 0x0000
	mov ss, ax
	mov ax, __stack_start
	add ax, 0x1000
	mov bp, ax
	mov sp, bp

	; Load 2nd onto SWIFTOS_STAGE2_SEGMNT:SWIFTOS_STAGE2_OFFSET
	;call boot_load
	;jmp $

	; Code exists Stage1 and enters Stage2 Here
	call c_main
	jmp $	

times 510-($-$$) db 0 ;510
dw 0xaaff			;Our magic number

section .text

;****************************************************
;		Include Stage1 Libraries
;****************************************************	

%include "asm/intcall.asm"

