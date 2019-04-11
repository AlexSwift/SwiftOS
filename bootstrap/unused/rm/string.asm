;***************************************************************************
;
;						swiftOS v0.5: Print String utils
;			with thanks to osdev.org and it's contributors
;***************************************************************************
	
bootstrap.string.newLine:

	push ax
	
	mov ah, 0Eh
	mov al, 0Ah
	int 10h
	mov al, 0Dh
	int 10h
	
	pop ax
	
	ret

bootstrap.string.printChar:

	push ax
	push bx
	
	mov bl, 0x0e
	mov ah, 0x0e
	int 0x10
    
	pop bx
	pop ax
	
	ret	

bootstrap.string.printPrefix:

	push si
	push ax

	mov si, bootstrap.msg.prefix
	
	.loop:
		lodsb
		test al,al
		jz .done
		call bootstrap.string.printChar
		jmp .loop

	.done:
		pop ax
		pop si
		ret
	
bootstrap.string.printString:
	
	push ax

	xor ax, ax

	cmp [bootstrap.msg.doPrefix], byte 0
	jpe .loop

	call bootstrap.string.printPrefix
	
	.loop:
	
		lodsb
		
		test al, al
		jz  .done
		
		call bootstrap.string.printChar
		
		jmp .loop
	
	.done:
		call bootstrap.string.newLine
	
		pop ax
	
		ret

; si - souce address 
; dx - source size
bootstrap.string.printHex:

	pusha

	mov al, "0"
	call bootstrap.string.printChar
	mov al, "x"
	call bootstrap.string.printChar

	;loop over every byte
	.loop:
		mov ax, 0
		mov bx, 0

		mov al, [si]
		and al, 0xf0
		shr al, 4
		mov bx, ax
		mov al, [bx + bootstrap.msg.hexLoopup]
		call bootstrap.string.printChar

		mov ax, 0
		mov bx, 0

		mov al, [si]
		and al, 0x0f
		mov bx, ax
		mov al, [bx + bootstrap.msg.hexLoopup]
		call bootstrap.string.printChar

		inc si
		dec dx
		cmp dx, 0
		jne .loop

	popa
	ret

; si - souce address 
; dx - source size
bootstrap.string.printHexLittleEndian:

	pusha

	mov al, "0"
	call bootstrap.string.printChar
	mov al, "x"
	call bootstrap.string.printChar

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
		call bootstrap.string.printChar

		mov ax, 0
		mov bx, 0

		mov al, [si]
		and al, 0x0f
		mov bx, ax
		mov al, [bx + bootstrap.msg.hexLoopup]
		call bootstrap.string.printChar

		dec si
		dec dx
		cmp dx, 0
		jne .loop

	popa
	ret

;return cx=0 for good comparison
bootstrap.string.compareString:

	pusha
	; expects si and di to be pointing at strings
	; cx is length of string

	mov ax, ds
	mov es, ax
	
	cld

	repe cmpsb
	jne .mismatch

	.match:
		popa
		mov cx, 0
		ret
	.mismatch:
		popa
		mov cx, 1
		ret

