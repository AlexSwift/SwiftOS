;***************************************************************************
;
;			        swiftOS v0.4: Definitions
;			with thanks to osdev.org and it's contributors
;***************************************************************************

; Define which file system we are to expect

%define OEM_ISO
;%define OEM_FAT12

SWIFTOS_BOOTLACE_SEGMNT 			equ 0x07c0
SWIFTOS_BOOTLACE_OFFSET 			equ 0x0000
SWIFTOS_BOOTLACE_RELOC_SEGMNT 		equ 0x07a0
SWIFTOS_BOOTLACE_RELOC_OFFSET 		equ 0x0000

; Where to load Stage1
; Note: we are still limited by 16 bits
SWIFTOS_BOOTSTRAP_SEGMNT 			equ 0x07c0
SWIFTOS_BOOTSTRAP_OFFSET 			equ 0x0000
SWIFTOS_BOOTSTRAP_SECTOR			equ 0x0001
SWIFTOS_BOOTSTRAP_SIZE				equ 0x0006

; Define the standard text mode limits
SWIFTOS_BOOTSTRAP_RES_X			equ	80
SWIFTOS_BOOTSTRAP_RES_Y			equ	25


; Where to load Stage2
; Note: we are still limited by 16 bits
SWIFTOS_KERNEL_SEGMNT 			equ 0x07e0
SWIFTOS_KERNEL_OFFSET 			equ 0x0000
SWIFTOS_KERNEL_SECTOR			equ 0x0002
SWIFTOS_KERNEL_SIZE				equ 0x04
