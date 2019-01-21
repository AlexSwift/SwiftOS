;***************************************************************************
;
;						swiftOS v0.3: Space Invaders (tm)
;			with thanks to osdev.org and it's contributors
;***************************************************************************

;****************************************************
;		Data
;****************************************************
global boot_letter

boot_letter:	db	0

disk:

.msg_error:	db	"Disk read error!", 0
.msg_succs:	db	"Disk read Successful!", 0

;****************************************************
;		Load Stage 2 onto disk
;****************************************************

.load:

	; Expects 	al 		= Number of sectors to read
	; 			es:bx 	= Destination to load to
	;			cx		= Sector to read from

    pusha
	
    mov  dl, [boot_letter]    	; boot drive
    xor  dh, dh             	; head 0
	
    mov si, 0x02    ; maximum attempts - 1
	
	.load_top:
	
		mov ah, 0x02    ; read sectors into memory (int 0x13, ah = 0x02)
		int 0x13
		
		jnc .load_end       ; exit if read succeeded
		dec si          	; decrement remaining attempts
		jc  .error        	; exit if maximum attempts exceeded
		xor ah, ah      	; reset disk system (int 0x13, ah = 0x00)
		int 0x13
		jnc .load_top        ; retry if reset succeeded, otherwise exit
		
	.load_end:
	
		mov si, .msg_succs
		call print16.string
		
		popa
		retn
	
	
	popa
	
	ret
	
.error:

		mov si, .msg_error
		call print16.string
		
		jmp $