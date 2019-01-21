;***************************************************************************
;
;						swiftOS v0.3: Init Protected Mode
;			with thanks to osdev.org and it's contributors
;***************************************************************************

;****************************************************
;		Load required environment for 32 bit
;****************************************************

stage1.proctectedMode:
.pre:

	; Disable Interupts
	call stage1.interupts

	; Announce we are about to setup Protected Mode
	mov si, stage1.msg.procPre
	call stage1.printString

	; Load GDT
	call stage1.gdt.load
	
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
	mov [stage1.video.x], dl
	mov [stage1.video.y], dh
	
	; Set Protected Mode
	;mov eax, cr0
	;or al, 1
	;mov cr0, eax
	
	; Jump into Protected Mode
	;jmp stage1.gdt.stage2_code:init32.post
	;jmp stage1.gdt.kernel_code:kmain
	jmp $