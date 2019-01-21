;***************************************************************************
;
;						swiftOS v0.3: Stage2
;			with thanks to osdev.org and it's contributors
;***************************************************************************

;****************************************************
;		Definitions of parameters
;****************************************************
bits		16
%include "../defines.asm"

extern stage2_main

;****************************************************
;		Trampoline to our main loader
;****************************************************

stage2_start:
jmp stage2_loader

;****************************************************
;		String Data
;****************************************************

msg:
.stage:				db	"[Stage2] ",0
.init:				db	"Bootloader:Stage 2 Initialized!",0
.done:				db	"          > Done",0
.protected_pre:			db	"Attempting to boot into 32-bit mode!",0

;****************************************************
;		Main Loader
;****************************************************

stage2_loader:
	; Save info of booting disk
	mov [ boot_letter ], dl
	
	call print16.graphic
	
	mov si, msg.init
	call print16.string
	
	call a20.enable
	
	call protected_mode.pre
	
	; Code doesn't return here
	jmp $
	
;****************************************************
;		Load Stage 2 Real Mode Libs
;****************************************************

%include "asm/rm/disk.asm"
%include "asm/rm/gdt.asm"
%include "asm/rm/print16.asm"
%include "asm/rm/graphic.asm"
%include "asm/rm/a20.asm"
%include "asm/rm/interupts.asm"
%include "asm/rm/protected.asm"

;****************************************************
;		Load Stage 2 Protected Mode Libs
;****************************************************
%include "asm/pm/init32.asm"	
%include "asm/pm/print32.asm"
