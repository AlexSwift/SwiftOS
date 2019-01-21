;***************************************************************************
;
;						swiftOS v0.3: Print Strings (PM)
;			with thanks to osdev.org and it's contributors
;***************************************************************************

;void video_copy( unsigned byte x, unsigned byte y ,uint32 *source, uint32 *length )
global video_copy
;void asmprintf( uint32 *str )
global asmprintf

;****************************************************
;		Video memory references
;****************************************************

SWIFTOS_STAGE2_VIDEO_MEMORY_LOW			equ 0x8000
SWIFTOS_STAGE2_VIDEO_MEMORY_HIGH_1		equ 0x0b
SWIFTOS_STAGE2_VIDEO_MEMORY_HIGH_2		equ 0x00
SWIFTOS_STAGE2_VIDEO_WHITE_ON_BLACK		equ 0x0f

video:
.x			db 0
.y			db 0
.counter		db 0

;****************************************************
;		Video functions
;****************************************************

video_copy:

	; stack:
	;	
	;	uint32 length +20
	;	uint32 *source +16
	;	unsigned int y +12
	;	unsigned int x +8
	;	ebp +4

	push ebp
	mov ebp, esp
	
	push eax
	push ebx	
	xor eax, eax
	xor ebx, ebx
	
	mov ax, gdt.stage2_video
	mov es, ax
	
	mov eax, DWORD [ss:(ebp + 12 )]	; unsigned int y
	mov bx, 80
	mul bx
	add eax, DWORD [ss:(ebp + 8)]	; unsigned int x
	mov bx, 2
	mul bx ;index is now in ax
	
	; Setup Source (SI) Destination (DI) with counter ECX
	mov di, ax
	mov si, WORD [ebp + 20]
	mov ecx, dword [ss:(ebp + 16)]
	rep movsw

	
	pop ebx
	pop eax
	pop ebp
	
	ret

;****************************************************
;		Print32 functions
;****************************************************

print32:
.string:

	; Expects ebx = pointer to string
	;		  es = video segment
	;		  ds = data segment

	pusha
	xor edx, edx
	mov dx, gdt.stage2_video
	mov es, dx
	
	xor eax, eax
	xor ecx, ecx
	
	mov al, byte [video.y]
	mov cx, 80
	mul cx
	add al, byte [video.x]
	mov cx, 2
	mul cx
	mov edx, eax		; Video memory is at beggining of segment
	
	.str_loop:
		mov al, [ebx]
		mov ah, SWIFTOS_STAGE2_VIDEO_WHITE_ON_BLACK
		
		cmp al,0
		je .str_done
		
		mov [es:edx], ax
		
		add ebx, 1
		add edx, 2
	jmp .str_loop
	
	.str_done:
	
		; store new video.x/y
		; edx contains new offset = x + 80*y
		mov eax, edx
		mov edx, 0
		mov ecx, 2
		div ecx
		mov ecx, 80
		div ecx
		mov [video.y], al
		add byte [video.y], 1
		mov byte [video.x], 0
	
		popa
		ret

asmprintf:

	push ebp
	mov ebp, esp
	
	xor ebx,ebx,
	mov bx, [ebp + 4]
	
	call print32.string
	

	pop ebp
	
	ret
	
