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

extern c_main
extern __stack_start

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

%include "intcall.asm"
%include "rm/disk.asm"
%include "rm/gdt.asm"
%include "rm/interupts.asm"
%include "rm/string.asm"
%include "rm/video.asm"

;****************************************************
;		Main Loader
;****************************************************

bootstrap.main:

	; Relocate OEM table to our copy before it gets over written by our stack
	mov cx, (0x0040 - 0x008)
	mov ax, SWIFTOS_BOOTLACE_RELOC_SEGMNT
	mov ds, ax
	mov ax, SWIFTOS_BOOTSTRAP_SEGMNT
	mov es, ax
	mov si, oem_bi_PrimaryVolumeDescriptor	;Same offset for both si,di
	mov di, oem_bi_PrimaryVolumeDescriptor	
	repnz movsb

	; Setup general segment registers
	mov ax, cs
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax

	mov ax, 0x7c0
	mov ss, ax
	mov ax, __stack_start
	add ax, 0x1000
	mov bp, ax
	mov sp, bp

	; Save Boot Drive letter for later use
	mov [bootstrap.bootDrive],dl

	call c_main
	jmp $ ;BREAKPOINT

	; Load Kernel into diskTransferBuffer
	call bootstrap.loadKernel
	
	; Wait for key press before booting into kernel
	;call bootstrap.keyWait

	; relocate kernel
	;mov cx, 0x800
	;mov ax, SWIFTOS_KERNEL_SEGMNT
	;mov es, ax
	;lea si, [bootstrap.diskTransferBuffer]
	;mov di, SWIFTOS_KERNEL_OFFSET
	;repnz movsb
	
	; Initializing.....
	mov si, bootstrap.msg.kernelInit
	call bootstrap.string.printString

	;call bootstrap.interupts

	mov si, bootstrap.msg.procPre
	call bootstrap.string.printString

	; Load GDT
	call bootstrap.gdt.load

	; Disable interupts
	call bootstrap.interupts.disable

	; Grab the boot drive data before we change our data segment
	mov dl, [bootstrap.bootDrive]

	call bootstrap.video.updateCursorPosition
	mov bl, byte [bootstrap.video.x]
	mov bh, byte [bootstrap.video.y]
	call bootstrap.video.disableCursor

	; Set Protected Mode
	mov eax, cr0
	or al, 1
	mov cr0, eax

	mov ax, bootstrap.gdt.kernel_data
	mov ds, ax

	; Setup stack segments
	;;mov ax, bootstrap.gdt.kernel_stack
	mov ss, ax
	
	; Set the Stack base to the base of our stack segment
	mov ebp, 0x7a00
	mov esp, ebp

	push dword 0x2BADB002
	call bootstrap.gdt.kernel_code:0x9000

	; Code exists Bootstrap and enters Kernel Here
	;jmp SWIFTOS_KERNEL_SEGMNT:SWIFTOS_KERNEL_OFFSET
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
