;***************************************************************************
;
;						swiftOS v0.3: Print String utils
;			with thanks to osdev.org and it's contributors
;***************************************************************************
	
bootstrap.newLine:

	push ax
	
	mov ah, 0Eh
	mov al, 0Ah
	int 10h
	mov al, 0Dh
	int 10h
	
	pop ax
	
	ret

bootstrap.printChar:

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
	push ax

	mov si, bootstrap.msg.prefix
	
	.printprefixloop:
		lodsb
		test al,al
		jz .prefixdone
		call bootstrap.printChar
		jmp .printprefixloop

	.prefixdone:
		pop ax
		pop si
		ret
	
bootstrap.printString:
	
	push ax
	push ds

	mov ax, cs
	mov ds, ax
	xor ax, ax

	cmp [bootstrap.msg.doPrefix], byte 0
	jpe .loop

	call bootstrap.printPrefix
	
	.loop:
	
		lodsb
		
		test al, al
		jz  .done
		
		call bootstrap.printChar
		
		jmp .loop
	
	.done:
		call bootstrap.newLine
	
		pop ds
		pop ax
	
		ret

; si - souce address 
; dx - source size
bootstrap.printHex:

	pusha

	mov al, "0"
	call bootstrap.printChar
	mov al, "x"
	call bootstrap.printChar

	;loop over every byte
	.loop:
		mov ax, 0
		mov bx, 0

		mov al, [si]
		and al, 0xf0
		shr al, 4
		mov bx, ax
		mov al, [bx + bootstrap.msg.hexLoopup]
		call bootstrap.printChar

		mov ax, 0
		mov bx, 0

		mov al, [si]
		and al, 0x0f
		mov bx, ax
		mov al, [bx + bootstrap.msg.hexLoopup]
		call bootstrap.printChar

		inc si
		dec dx
		cmp dx, 0
		jne .loop

	popa
	ret

; si - souce address 
; dx - source size
bootstrap.printHexLittleEndian:

	pusha

	mov al, "0"
	call bootstrap.printChar
	mov al, "x"
	call bootstrap.printChar

	add si, dx
	dec si

	;loop over every byte
	.loop:
		mov ax, 0
		mov bx, 0

		mov al, [si]
		and al, 0xf0
		shr al, 4
		mov bx, ax
		mov al, [bx + bootstrap.msg.hexLoopup]
		call bootstrap.printChar

		mov ax, 0
		mov bx, 0

		mov al, [si]
		and al, 0x0f
		mov bx, ax
		mov al, [bx + bootstrap.msg.hexLoopup]
		call bootstrap.printChar

		dec si
		dec dx
		cmp dx, 0
		jne .loop

	popa
	ret


