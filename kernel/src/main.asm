;***************************************************************************
;
;				swiftOS v0.5: BootStrap
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
jmp SWIFTOS_KERNEL_SEGMNT:kernel.main

;****************************************************
;		Data
;****************************************************

%include "data.asm"

;****************************************************
;		Include Kernel Libraries
;****************************************************	

%include "rm/print_string.asm"

;****************************************************
;		Main Loader
;****************************************************

kernel.main:

	; Setup Registers (Only what we need right now)

	mov ax, cs
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax

	; If we relocate straight away to 0x7a00-0x7c00, then stack could be based at 0x7a00
	; ss should be 0 in order for ss:sp to not wrap around
	mov ax, 0
	mov ss, ax
	mov bp, 0x7a00
	mov sp, 0x7a00

	mov si, kernel.msg.welcome
	call kernel.printString

	jmp $
