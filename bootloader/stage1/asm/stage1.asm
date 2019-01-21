;***************************************************************************
;
;						swiftOS v0.3: Boot Sector
;			with thanks to osdev.org and it's contributors
;***************************************************************************

;****************************************************
;		Definitions of parameters
;****************************************************

bits		16
%include "../defines.asm"

;****************************************************
;		Trampoline to our main loader
;****************************************************

stage1.entry:
jmp SWIFTOS_STAGE1_SEGMNT:stage1.main

;****************************************************
;		Allign and setup OEM block
;****************************************************

%include "asm/rm/oem.asm"

;****************************************************
;		Data
;****************************************************

%include "asm/data.asm"

;****************************************************
;		Include Stage1 Libraries
;****************************************************	

%include "asm/rm/a20.asm"
%include "asm/rm/disk.asm"
%include "asm/rm/e820.asm"
%include "asm/rm/gdt.asm"
%include "asm/rm/interupts.asm"
%include "asm/rm/protected.asm"
%include "asm/rm/string.asm"

;****************************************************
;		Main Loader
;****************************************************

stage1.main:

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
	mov [stage1.bootDrive],dl

	; Print our fancy graphic (disable prefix)
	mov [stage1.msg.doPrefix], byte 0
	mov si, stage1.graphic2
	call stage1.printString
	mov [stage1.msg.doPrefix], byte 1

	; Print that we've landed in Stage1
	mov si, stage1.msg.init
	call stage1.printString

	; Enable A20 memory line
	call stage1.a20.enable

	; Get memory map
	call stage1.e820.fetchMap

	; Print memory fetch
	;call stage1.e820.printMap

	; Enable protected mode
	call stage1.proctectedMode

	; Load 2nd onto SWIFTOS_STAGE2_SEGMNT:SWIFTOS_STAGE2_OFFSET
	;call stage1.loadStage2
	
	; Wait for key press before booting into stage2
	;call stage1.keyWait
	
	; Initializing.....
	;mov si, stage1.msg.stage2Init
	;call stage1.printString

	; Grab the boot drive data before we change our data segment
	;mov dl, [stage1.bootDrive]
	
	; Setup the data stack pointer so our stage2 doesn't have to do it
	;mov ax, SWIFTOS_STAGE2_SEGMNT
	;mov ds, ax
	
	; Code exists Stage1 and enters Stage2 Here
	;jmp SWIFTOS_STAGE2_SEGMNT:SWIFTOS_STAGE2_OFFSET
	jmp $

	
;****************************************************
;		Wait for key press
;****************************************************

stage1.keyWait:

	mov si, stage1.msg.keyWait
	call stage1.printString
	
	push ax

	mov     ah, 00h
	int     16h
	
	pop ax
	
	ret
