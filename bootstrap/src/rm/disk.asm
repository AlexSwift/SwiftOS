;***************************************************************************
;
;						swiftOS v0.3: Disk Loading (stage2)
;			with thanks to osdev.org and it's contributors
;***************************************************************************

;****************************************************
;		Load Stage2
;****************************************************

bootstrap.loadStage2:

	mov si, bootstrap.msg.loadStage2
	call bootstrap.printString

	pusha	

	cld 	
	mov cx, 0x02    ; maximum attempts - 1
	.top:
		xor dx, dx
		mov dl, [bootstrap.bootDrive]
		lea si, [bootstrap.DAP]
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

