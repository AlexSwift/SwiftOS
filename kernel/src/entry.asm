;***************************************************************************
;
;				swiftOS v0.5: BootStrap
;			with thanks to osdev.org and it's contributors
;***************************************************************************

;****************************************************
;		Definitions of parameters
;****************************************************

bits		32
%include "defines.asm"

global entry

extern kernel_main

;****************************************************
;		Trampoline to our main loader
;****************************************************

section .stub

entry:
call kernel.entry

;****************************************************
;		Data
;****************************************************

%include "data.asm"

;****************************************************
;		Main Loader
;****************************************************

kernel.entry:

	; Setup Registers (Only what we need right now)

	mov eax, ds
	mov es, eax
	mov fs, eax
	mov gs, eax

	mov [bootstrap_video_x], bl
	mov [bootstrap_video_y], bh

	call kernel_main
	jmp $

section .text
