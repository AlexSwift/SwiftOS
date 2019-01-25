;***************************************************************************
;
;						swiftOS v0.4: Print String utils
;			with thanks to osdev.org and it's contributors
;***************************************************************************

bootstrap.clearScreen:

	; Uses ax,bx,cx,dx
	
	pusha

	; Move cursor at top left position
	mov ah, 0x02
	xor bx, bx
	xor dx, dx
	int 0x10

    	; Clear screen
	mov ax, 0x0600
	mov bx, 0x0700
	xor cx, cx
	mov dx, 0x184f
	int 0x10

	popa
	
	ret
	
bootstrap.newLine:

	push ax
	
	mov ax, 0x0e0a
	int 10h
	mov al, 0Dh
	int 10h
	
	pop ax
	
    	ret

bootstrap.putChar:

	push ax
	push bx
	
	mov bl, 0x0e
	mov ah, 0x0e
	int 0x10
    
	pop bx
	pop ax
	
	ret	
	
bootstrap.printPrefix:

	push si

	mov si, bootstrap.msg.prefix
	
	.printprefixloop:
		lodsb
		test al,al
		jz .prefixdone
		call bootstrap.putChar
		jmp .printprefixloop

	.prefixdone:

	pop si
	ret
	
bootstrap.printString:
	
	push ax
	push ds

	mov ax, cs
	mov ds, ax
	xor ax, ax

	call bootstrap.printPrefix
	
	.loop:
	
		lodsb
		
		test al, al
		jz  .done
		
		call bootstrap.putChar
		
		jmp .loop
	
	.done:
	call bootstrap.newLine
	
	pop ds
	pop ax
	
	ret
