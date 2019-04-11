bootstrap.video.disableCursor:

	push ax
	push cx

	xor ax, ax
	mov ah, 0x01
	mov cx, 0x2607
	int 0x10

	pop cx
	pop ax
	ret

bootstrap.video.updateCursorPosition:

	push ax
	push dx

	xor ax, ax
	xor dx, dx
	mov ah, 0x03
	int 0x10

	mov byte [bootstrap.video.x], dl
	mov byte [bootstrap.video.y], dh

	pop dx
	pop ax
	ret