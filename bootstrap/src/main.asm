;***************************************************************************
;
;						swiftOS v0.5: Boot Sector
;			with thanks to osdev.org and it's contributors
;***************************************************************************

;****************************************************
;		Definitions of parameters
;****************************************************

bits		16
%include "defines.asm"
global entry

;****************************************************
;		Trampoline to our main loader
;****************************************************

entry:
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

	; Relocate OEM table to our copy before it gets over written by our stack
	mov cx, 0x0040
	mov ax, SWIFTOS_BOOTLACE_RELOC_SEGMNT
	mov ds, ax
	mov ax, SWIFTOS_BOOTSTRAP_SEGMNT
	mov es, ax
	mov si, bootstrap.OEM.bi_PrimaryVolumeDescriptor	;Same offset for both si,di
	mov di, bootstrap.OEM.bi_PrimaryVolumeDescriptor	
	repnz movsb

	; Setup general segment registers
	mov ax, cs
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax

	; Setup stack registers 
	mov ax, 0
	mov ss, ax
	mov bp, SWIFTOS_BOOTSTRAP_SEGMNT << 4
	mov sp, bp

	; Save Boot Drive letter for later use
	mov [bootstrap.bootDrive],dl

	; Print our fancy graphic (disable prefix)
	mov [bootstrap.msg.doPrefix], byte 0
	mov si, bootstrap.graphic
	call bootstrap.string.printString
	mov [bootstrap.msg.doPrefix], byte 1

	; Print that we've landed in Stage1
	mov si, bootstrap.msg.init
	call bootstrap.string.printString

	; Enable A20 memory line
	call bootstrap.a20.enable

	; Get memory map
	call bootstrap.e820.fetchMap

	; Print memory fetch
	;call bootstrap.e820.printMap

	; Load Kernel into diskTransferBuffer
	call bootstrap.loadKernel
	
	; Wait for key press before booting into kernel
	;call bootstrap.keyWait
	
	; Initializing.....
	mov si, bootstrap.msg.kernelInit
	call bootstrap.string.printString

	; Enable protected mode
	;call bootstrap.proctectedMode
	
	; relocate kernel
	mov cx, 0x0200
	mov ax, SWIFTOS_KERNEL_SEGMNT
	mov es, ax
	lea si, [bootstrap.diskTransferBuffer]
	mov di, SWIFTOS_KERNEL_OFFSET
	repnz movsb

	; Grab the boot drive data before we change our data segment
	mov dl, [bootstrap.bootDrive]

	mov ax, SWIFTOS_KERNEL_SEGMNT
	mov ds, ax

	; Code exists Bootstrap and enters Kernel Here
	jmp SWIFTOS_KERNEL_SEGMNT:SWIFTOS_KERNEL_OFFSET
	jmp $

	
;****************************************************
;		Wait for key press
;****************************************************

bootstrap.keyWait:

	push si
	mov si, bootstrap.msg.keyWait
	call bootstrap.string.printString
	pop si
	
	push ax

	mov ah, 00h
	int 16h
	
	pop ax
	
	ret
