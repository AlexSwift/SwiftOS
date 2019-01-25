;***************************************************************************
;
;						swiftOS v0.3: Boot Sector
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

bootstrap.entry:
jmp SWIFTOS_BOOTSTRAP_SEGMNT:bootstrap.main

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

%include "rm/a20.asm"
%include "rm/disk.asm"
%include "rm/e820.asm"
%include "rm/gdt.asm"
%include "rm/interupts.asm"
%include "rm/protected.asm"
%include "rm/string.asm"

;****************************************************
;		Main Loader
;****************************************************

bootstrap.main:

	; Setup general segment registers
	mov ax, cs
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax

	; Setup stack registers 
	; (Optimize this with build, set ss to 0x07a0, bp and sp to 0x0200 - maybe with variable stack size )
	mov ax, 0
	mov ss, ax
	mov bp, 0x7c00
	mov sp, 0x7C00

	; Save Boot Drive letter for later use
	mov [bootstrap.bootDrive],dl

	; Print our fancy graphic (disable prefix)
	mov [bootstrap.msg.doPrefix], byte 0
	mov si, bootstrap.graphic2
	call bootstrap.printString
	mov [bootstrap.msg.doPrefix], byte 1

	; Print that we've landed in Stage1
	mov si, bootstrap.msg.init
	call bootstrap.printString

	; Enable A20 memory line
	call bootstrap.a20.enable

	; Get memory map
	call bootstrap.e820.fetchMap

	; Print memory fetch
	call bootstrap.e820.printMap

	; Enable protected mode
	call bootstrap.proctectedMode

	; Load 2nd onto SWIFTOS_STAGE2_SEGMNT:SWIFTOS_STAGE2_OFFSET
	;call bootstrap.loadStage2
	
	; Wait for key press before booting into stage2
	;call bootstrap.keyWait
	
	; Initializing.....
	;mov si, bootstrap.msg.stage2Init
	;call bootstrap.printString

	; Grab the boot drive data before we change our data segment
	;mov dl, [bootstrap.bootDrive]
	
	; Setup the data stack pointer so our stage2 doesn't have to do it
	;mov ax, SWIFTOS_STAGE2_SEGMNT
	;mov ds, ax
	
	; Code exists Stage1 and enters Stage2 Here
	;jmp SWIFTOS_STAGE2_SEGMNT:SWIFTOS_STAGE2_OFFSET
	jmp $

	
;****************************************************
;		Wait for key press
;****************************************************

bootstrap.keyWait:

	mov si, bootstrap.msg.keyWait
	call bootstrap.printString
	
	push ax

	mov     ah, 00h
	int     16h
	
	pop ax
	
	ret
