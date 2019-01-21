;***************************************************************************
;
;						swiftOS v0.3: Disk Loading (stage2)
;			with thanks to osdev.org and it's contributors
;***************************************************************************

;****************************************************
;		Load Stage2
;****************************************************

stage1.loadStage2:

	mov si, stage1.msg.loadStage2
	call stage1.printString

	pusha	

	cld 	
	mov cx, 0x02    ; maximum attempts - 1
	.top:
		xor dx, dx
		mov dl, [stage1.bootDrive]
		lea si, [stage1.DAP]
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
		mov si, stage1.msg.disk.succ
		call stage1.printString
		popa
		retn
	
	.errorjc:
		mov si, stage1.msg.disk.error
		call stage1.printString
		jmp $

