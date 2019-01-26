;***************************************************************************
;
;			swiftOS v0.5: Disk Loading (bootlace)
;		with thanks to osdev.org and it's contributors
;***************************************************************************

;****************************************************
;		Load Stage1
;****************************************************

bootloader.loadStage1:

	pusha	

	cld 	
	mov cx, 0x02    ; maximum attempts - 1
	.top:
		xor dx, dx
		mov dl, [bootlace.bootDrive]
		lea si, [bootloader.DAP]
		mov ah, 0x42	; read sectors into memory (int 0x13, ah = 0x02)
		int 0x13
		jnc .end	; exit if read succeeded
		dec cx		; decrement remaining attempts
		cmp cx, 0
		je  .errorjc	; exit if maximum attempts exceeded
		xor ah, ah      ; reset disk system (int 0x13, ah = 0x00)
		int 0x13
		jnc .top		; retry if reset succeeded, otherwise exit
	.errorjc:
		mov si, bootlace.msg.disk.error
		call bootlace.printString
		jmp $
	.end:
		mov si, bootlace.msg.disk.succ
		call bootlace.printString
		popa
		retn

