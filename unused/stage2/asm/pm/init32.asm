;***************************************************************************
;
;						swiftOS v0.3: Init Protected Mode
;			with thanks to osdev.org and it's contributors
;***************************************************************************

[bits 32]

extern stage2_main

;****************************************************
;		String Data
;****************************************************

init32:
.msg_success		db "[Stage2] Successfully booted into 32-bit mode!",0
	
;****************************************************
;		Begin Execution in 32 bits
;****************************************************
	
.post:

	; Setup data segments
	mov ax, gdt.stage2_data
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	
	; Setup stack segments
	mov ax, gdt.stage2_stack
	mov ss, ax
	
	; Set the Stack base to the base of our stack segment
	mov ebp, 0x0000
	mov esp, ebp

	; Let the user know we've landed in 32bit
	mov ebx, .msg_success
	call print32.string

	;call SWIFTOS_STAGE2_INT_DISABLE
	
	; Jump into the C++ main routine
	call stage2_main
	
	; Should never return here, but if we do, hang.
	jmp $
