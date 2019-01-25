;***************************************************************************
;
;			swiftOS v0.3: E820 memory map
;			with thanks to osdev.org and it's contributors
;***************************************************************************

bootstrap.e820.fetchMap:
	
	pusha

	mov si, bootstrap.msg.e820.fetchMap
	call bootstrap.printString

	; Entries are stored in es:di; es is already a copy of ds
	mov di, bootstrap.e820.data
	xor ebx, ebx
	xor bp, bp
	mov edx, 0x0534D4150		; Place signature in edx
	mov eax, 0xe820
	mov [es:di + 20], dword 1	; We will set every entry to be 24 byes long. set 20-24 bytes to 1 as backup
	mov ecx, 24					; We expect 24 bytes of data
	int 0x15					; E820

	; Carry flag signals unsopported feature
	jc .unsupported

	; Check signature is cohessive
	mov edx, 0x0534D4150
	cmp eax, edx
	jne .unsupported

	; Check if list is longer than 1 entry
	test ebx, ebx
	je .unsupported

	jmp .mainloop_main

	.mainloop:
		mov eax, 0xe820				; eax, ecx get trashed on every int 0x15 call
		mov [es:di + 20], dword 1	; force a valid ACPI 3.X entry
		mov ecx, 24					; ask for 24 bytes again
		int 0x15
		jc short .finished			; Carry set, we are finished
		mov edx, 0x0534D4150		; Reset edx

	.mainloop_main:
		jcxz .skipEntry				; skip any 0 length entries
		cmp cl, 20					; got a 24 byte ACPI 3.X response?
		jbe .notExtended
		test byte [es:di + 20], 1	; if so: is the "ignore this data" bit clear?
		je .skipEntry

	; No extended ACPI 3.X response
	.notExtended:
		mov ecx, [es:di + 8]	; get lower uint32_t of memory region length
		or ecx, [es:di + 12]	; "or" it with upper uint32_t to test for zero
		jz .skipEntry	; if length uint64_t is 0, skip entry
		inc bp			; got a good entry: ++count, move to next storage spot
		add di, 24

	.skipEntry:
		test ebx, ebx		; if ebx resets to 0, list is complete
		jne short .mainloop
		jmp .finished

	.unsupported:
		mov si, bootstrap.msg.e820.nosupp
		call bootstrap.printString
		jmp $

	.finished:
		mov [bootstrap.e820.entries], bp	; store the entry count
		clc			; there is "jc" on end of list to this point, so the carry must be cleared

		mov si, bootstrap.msg.done
		call bootstrap.printString

		popa 			
		ret


bootstrap.e820.printMap:

	pusha

	mov ax, bootstrap.e820.data
	mov bx, 0
	mov cx, [bootstrap.e820.entries]
	mov dx, 0
	mov si, bootstrap.e820.data

	.loop:

		mov dx, 8
		call bootstrap.printHexLittleEndian

		mov al, "-"
		call bootstrap.printChar

		add si, 8
		mov dx, 8
		call bootstrap.printHexLittleEndian

		mov al, " "
		call bootstrap.printChar

		add si, 8
		mov dx, 4
		call bootstrap.printHexLittleEndian

		call bootstrap.newLine

		add si, 8
		dec cx
		cmp cx, 0
		jne .loop

	popa
	ret