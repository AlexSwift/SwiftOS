;***************************************************************************
;
;						swiftOS v0.3: Print String utils
;			with thanks to osdev.org and it's contributors
;***************************************************************************
	
stage1.newLine:

	push ax
	
	mov ah, 0Eh
	mov al, 0Ah
	int 10h
	mov al, 0Dh
	int 10h
	
	pop ax
	
	ret

stage1.printChar:

	push ax
	push bx
	
	mov bl, 0x0e
	mov ah, 0x0e
	int 0x10
    
	pop bx
	pop ax
	
	ret	

stage1.printPrefix:

	push si
	push ax

	mov si, stage1.msg.prefix
	
	.printprefixloop:
		lodsb
		test al,al
		jz .prefixdone
		call stage1.printChar
		jmp .printprefixloop

	.prefixdone:
		pop ax
		pop si
		ret
	
stage1.printString:
	
	push ax
	push ds

	mov ax, cs
	mov ds, ax
	xor ax, ax

	cmp [stage1.msg.doPrefix], byte 0
	jpe .loop

	call stage1.printPrefix
	
	.loop:
	
		lodsb
		
		test al, al
		jz  .done
		
		call stage1.printChar
		
		jmp .loop
	
	.done:
		call stage1.newLine
	
		pop ds
		pop ax
	
		ret

; si - souce address 
; dx - source size
stage1.printHex:

	pusha

	mov al, "0"
	call stage1.printChar
	mov al, "x"
	call stage1.printChar

	;loop over every byte
	.loop:
		mov ax, 0
		mov bx, 0

		mov al, [si]
		and al, 0xf0
		shr al, 4
		mov bx, ax
		mov al, [bx + stage1.msg.hexLoopup]
		call stage1.printChar

		mov ax, 0
		mov bx, 0

		mov al, [si]
		and al, 0x0f
		mov bx, ax
		mov al, [bx + stage1.msg.hexLoopup]
		call stage1.printChar

		inc si
		dec dx
		cmp dx, 0
		jne .loop

	popa
	ret

; si - souce address 
; dx - source size
stage1.printHexLittleEndian:

	pusha

	mov al, "0"
	call stage1.printChar
	mov al, "x"
	call stage1.printChar

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
		mov al, [bx + stage1.msg.hexLoopup]
		call stage1.printChar

		mov ax, 0
		mov bx, 0

		mov al, [si]
		and al, 0x0f
		mov bx, ax
		mov al, [bx + stage1.msg.hexLoopup]
		call stage1.printChar

		dec si
		dec dx
		cmp dx, 0
		jne .loop

	popa
	ret


