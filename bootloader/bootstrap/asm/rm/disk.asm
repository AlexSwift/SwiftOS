;***************************************************************************
;
;			swiftOS v0.4: Disk Loading (bootstrap)
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
		mov dl, [bootstrap.bootDrive]
		lea si, [bootloader.DAP]
		mov ah, 0x42	; read sectors into memory (int 0x13, ah = 0x02)
		int 0x13
		jnc .end	; exit if read succeeded
		dec cx		; decrement remaining attempts
		cmp cx, 0
		je  .errorjc	; exit if maximum attempts exceeded
		xor ah, ah      ; reset disk system (int 0x13, ah = 0x00)
		int 0x13
		jc .top		; retry if reset succeeded, otherwise exit
	.end:
		mov si, bootstrap.msg.disk.succ
		call bootstrap.printString
		popa
		retn
	
	.errorjc:
		mov si, bootstrap.msg.disk.error
		call bootstrap.printString
		jmp $

