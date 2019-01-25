;***************************************************************************
;
;						swiftOS v0.3: A20 Memory Lane
;			with thanks to osdev.org and it's contributors
;***************************************************************************

;****************************************************
;		Main Routine
;****************************************************

stage1.a20.enable:

	; Save clobber registers
	push ax
	push si
	
	; Print that we are attempting to enable A20 memory line
	mov si, stage1.msg.a20.enable
	call stage1.printString

	; Enable A20 through ps/2
	in ax, 0x92
	or ax, 0x02
	and ax, 0xFE
	out 0x92, ax
	
	; Check if A20 is enabled
	mov ax, 2401h
	int 15
	
	; call our error handler
	call .error
	
	mov si, stage1.msg.done
	call stage1.printString
	
	pop si
	pop ax
	
	ret
	
	.error:
	
		push ax
	
		cmp ah, 0x86
		je .errorNotSupported
		cmp ah, 01h
		je .errorSecureMode
	
		pop ax

		ret
	
	.errorNotSupported:
	
		mov si, stage1.msg.a20.nosupp
		call stage1.printString
	
		jmp $
	
	.errorSecureMode:
	
		mov si, stage1.msg.a20.secmode
		call stage1.printString
	
		jmp $