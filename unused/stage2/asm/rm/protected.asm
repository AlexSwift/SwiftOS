;***************************************************************************
;
;						swiftOS v0.3: Init Protected Mode
;			with thanks to osdev.org and it's contributors
;***************************************************************************

;****************************************************
;		Load required environment for 32 bit
;****************************************************

protected_mode:
.pre:

	; Disable Interupts
	call interupts.disable

	; Announce we are about to setup Protected Mode
	mov si, msg.protected_pre
	call print16.string

	; Load GDT
	call gdt.load
	
	; Load IDT
	;call SWIFTOS_STAGE2_IDT_LOAD
	
	; Reprogram PICs
	;call SWIFTOS_STAGE2_PIC_LOAD
	
	; Load TSS
	;call SWIFTOS_STAGE2_TSS_LOAD
	
	; Setup Page Tables and CR3 (optional, perhaps for stage 3/ kernel?)
	
	; Setup cursor data, no prints after this please
	xor ax, ax
	xor bx, bx
	mov ah, 0x03
	mov bh, 0
	int 0x10
	mov [video.x], dl
	mov [video.y], dh
	
	; Set Protected Mode
	mov eax, cr0
	or al, 1
	mov cr0, eax
	
	; Jump into Protected Mode
	jmp gdt.stage2_code:init32.post