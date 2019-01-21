;***************************************************************************
;
;						swiftOS v0.3: String Util Lib
;			with thanks to osdev.org and it's contributors
;***************************************************************************

print16:

.prefix:	db	0

.cr:
	push ax

	mov ah, 0Eh
	mov al, 0Ah
	int 10h

	mov al, 0Dh
	int 10h

	pop ax
	ret

.char:
	push ax
	push bx

	mov bx, 0x0F
	mov ah, 0x0E
	int 0x10

	pop bx
	pop ax

	ret

.printprefix:

	push si

	mov si, msg.stage
	
	.printprefixloop:
		lodsb
		test al,al
		jz .prefixdone
		call .char
		jmp .printprefixloop

	.prefixdone:

	pop si
	ret

.string:
	
	cmp byte [.prefix], 0
	je .str_main
	call .printprefix
	
	.str_main:
		lodsb
		test al, al
		jz  .done
		call .char
		jmp .str_main

	.done:
	call .cr
	ret

.graphic:

	push si
	
	mov byte [.prefix], 0

	mov si, stage2_graphic
	call .string

	mov byte [.prefix], 1

	pop si
	
	ret
