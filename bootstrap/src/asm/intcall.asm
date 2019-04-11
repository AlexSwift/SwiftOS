global intcall

intcall:

	push bp
	mov bp, sp
	
	pushfd	; 4 bytes
	push fs	; 2 bytes
	push gs	; 2 bytes
	pushad	; 32 bytes

	mov al, byte [bp + 6]
	mov [.in], al

	sub sp, 44	;Alocate  sizeof(intregs)
	mov si, [bp + 10]
	mov di, sp
	mov cx, 11
	rep movsd

	; Modify SP and BP

	mov bx, sp
	mov [bx+8], bp
	mov [bx+12], sp

	popad
	pop gs
	pop fs
	pop es
	pop ds
	popfd

	; do the interupt
	db 0xcd
.in:db 0

	pushfd
	push ds
	push es
	push fs
	push gs
	pushad

	mov si, sp
	mov di, [bp + 14]
	mov cx, 11
	rep movsd

	add sp, 44

	popad
	pop gs
	pop fs
	popfd

	mov sp, bp
	pop bp

	ret