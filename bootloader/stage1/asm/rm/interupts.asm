;***************************************************************************
;
;						swiftOS v0.3: Init Protected Mode
;			with thanks to osdev.org and it's contributors
;***************************************************************************

;****************************************************
;		Enable/Disable Interupts
;****************************************************
stage1.interupts:
.enable:

	push ax
	
	; Enable INTs
	sti

	; Enable NMI
	in al, 0x70
	and al, 0xF7
	out 0x70, al

	pop ax
	
	ret

.disable:

	; Disable Software interupts
	cli
	
	; Disable Non Maskable Interupts (NMI)
	in al, 0x70
	or al, 0x80
	out 0x70, al

	ret