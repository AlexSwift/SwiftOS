;***************************************************************************
;
;				swiftOS v0.4: BootStrap
;			with thanks to osdev.org and it's contributors
;***************************************************************************

;****************************************************
;		Definitions of parameters
;****************************************************

bits		16
%include "defines.asm"

;****************************************************
;		Trampoline to our main loader
;****************************************************

bootlace.entry:
jmp 0x07c0:bootlace.relocate

;****************************************************
;		Allign and setup OEM block
;****************************************************

%include "rm/oem.asm"

;****************************************************
;		Data
;****************************************************

%include "data.asm"

;****************************************************
;		Include Stage1 Libraries
;****************************************************	

%include "rm/disk.asm"
%include "rm/print_string.asm"

;****************************************************
;		Main Loader
;****************************************************

bootlace.relocate:

	; Setup Registers (Only what we need right now)

	mov ax, cs
	mov ds, ax
	mov es, ax

	; If we relocate straight away to 0x7a00-0x7c00, then stack could be based at 0x7a00
	; ss should be 0 in order for ss:sp to not wrap around
	mov ax, 0
	mov ss, ax
	mov bp, 0x7a00
	mov sp, 0x7a00

	; Save Boot Drive letter for later use
	mov [bootlace.bootDrive],dl
	
	; Clear Screen
	; Is this needed? Screen might be black
	;call bootloader.clearScreen

	; Relocation of 0x7c00-0x7e00 -> 0x7a00-0x7c00 
	mov cx, 0x0200
	mov ax, SWIFTOS_BOOTLACE_RELOC_SEGMNT
	mov es, ax
	mov si, 0x0000
	mov di, SWIFTOS_BOOTLACE_RELOC_OFFSET
	repnz movsb

	; Jump to 0x07e0: $+1 in order to continue control flow in new segment
	; Reset segments to 0x07a0
	; segment 0x07c0 is now free again

	mov ax, SWIFTOS_BOOTLACE_RELOC_SEGMNT
	mov ds,ax
	
	jmp SWIFTOS_BOOTLACE_RELOC_SEGMNT:(SWIFTOS_BOOTLACE_RELOC_OFFSET + bootlace.relocated)
	

bootlace.relocated:

	mov ax, cs
	mov ds, ax

	; Load 2nd onto SWIFTOS_STAGE2_SEGMNT:SWIFTOS_STAGE2_OFFSET
	call bootloader.loadStage1

	; Grab the boot drive data before we change our data segment
	mov dl, [bootlace.bootDrive]
	
	; Setup the data stack pointer so our stage2 doesn't have to do it
	mov ax, SWIFTOS_BOOTSTRAP_SEGMNT
	mov ds, ax
	
	; Code exists Stage1 and enters Stage2 Here
	jmp SWIFTOS_BOOTSTRAP_SEGMNT:SWIFTOS_BOOTSTRAP_OFFSET
	jmp $	

times 510-($-$$) db 0 ;510

dw 0xaaff			;Our magic number
