;***************************************************************************
;
;						swiftOS v0.5: A20 Memory Lane
;			with thanks to osdev.org and it's contributors
;***************************************************************************

;****************************************************
;		Main Routine
;****************************************************

bootstrap.a20.enable:

	; Save clobber registers
	push ax
	push si
	
	; Print that we are attempting to enable A20 memory line
	mov si, bootstrap.msg.a20.enable
	call bootstrap.string.printString

	; Enable A20 through ps/2
	in ax, 0x92
	or ax, 0x02
	and ax, 0xFE
	out 0x92, ax
	
	; Check if A20 is enabled
	mov ax, 2401h
	int 15
	
	cmp ah, 0x86
	je .errorNotSupported
	cmp ah, 01h
	je .errorSecureMode
	
	mov si, bootstrap.msg.done
	call bootstrap.string.printString
	
	pop si
	pop ax
	
	ret
	
	.errorNotSupported:
	
		mov si, bootstrap.msg.a20.nosupp
		call bootstrap.string.printString
	
		pop si
		pop ax

		jmp $
	
	.errorSecureMode:
	
		mov si, bootstrap.msg.a20.secmode
		call bootstrap.string.printString

		pop si
		pop ax
	
		jmp $