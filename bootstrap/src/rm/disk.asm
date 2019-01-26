;***************************************************************************
;
;						swiftOS v0.5: Disk Loading (stage2)
;			with thanks to osdev.org and it's contributors
;***************************************************************************

;****************************************************
;		Load Stage2
;****************************************************

bootstrap.loadKernel:

	pusha

	; Announce that we are loading the Kernel image
	mov si, bootstrap.msg.loadKernel
	call bootstrap.string.printString

	; load the LBA of the Primary Volume Descriptor
	;mov ax, SWIFTOS_BOOTLACE_RELOC_SEGMNT
	;mov es, ax
	;push word [es:SWIFTOS_BOOTLACE_RELOC_OFFSET + 8]
	push word [bootstrap.OEM.bi_PrimaryVolumeDescriptor]
	pop  word [bootstrap.DAP.lbaLow]
	; Load the disk data
	call bootstrap.loadDiskData

	; Store length in bytes of sectors
	push word [ bootstrap.diskTransferBuffer + 128 ]
	pop  word [ bootstrap.sectorLength ]
	; Calculate the number of sectors to load per LBA for Root Directory Extent
	mov ax, [ bootstrap.diskTransferBuffer + 156 + 10 ]
	mov dx, [ bootstrap.diskTransferBuffer + 156 + 12 ]
	div word [ bootstrap.sectorLength ]
	; Load at least 1 sector 
	; TODO: Make sure we don't load data when both ax,dx are 0
	cmp ax, 0
	jne .min
	mov ax, 1
	.min:
	mov word [bootstrap.DAP.SectorsToRead], ax

	; Setup our DAP with the correct LBA of the Root Directory Extent
	push word [bootstrap.diskTransferBuffer + 156 + 2 ] ; 156 is the offset of the root directory
	push word [bootstrap.diskTransferBuffer + 156 + 4 ] ; 156 is the offset of the root directory
	pop word [bootstrap.DAP.lbaLow + 2] ; 2-4 little endian is the LBA location of extent root directory
	pop word [bootstrap.DAP.lbaLow]
	; Load disk data
	call bootstrap.loadDiskData

	; We now have a bunch of directory entries in our buffer
	; Search through all of them for "KERNEL.BIN;1"
	; TODO: Have the ability to load images from sub directories
	mov si, 0
	.loop:
		; Store size of entry in order to iterate through
		mov ax, [bootstrap.diskTransferBuffer + si]
		; Terminate search when we reach a block of data size 0
		cmp ax, 0
		je .notFound

		; Store si, needed to compare filenames
		push si

		mov di, bootstrap.msg.kernel.name
		lea si, [bootstrap.diskTransferBuffer + si + 33]
		xor cx, cx
		mov cl, byte [bootstrap.msg.kernel.length]
		call bootstrap.string.compareString

		; Restore si to be our index counter
		pop si

		; We have found our file when the number of letters from the end of the string for a mismatch
		; is 0. Meaning all letters are correct
		cmp cx, 0
		je .found

		; Increment our index counter and loop 
		add si, ax
		jmp .loop

	.found:

		; si now stores the offset in the diskTransferBuffer to the entry of our kernel image

		; Similar to above, we load the number of sectors of the image into our DAP
		mov ax, [ bootstrap.diskTransferBuffer + si + 10 ]
		mov dx, [ bootstrap.diskTransferBuffer + si + 12 ]
		div word [ bootstrap.sectorLength ]
		cmp ax, 0
		jne .min2
		mov ax, 1
		.min2:
		mov word [bootstrap.DAP.SectorsToRead], ax
		; Same again, we store the LBA of file to load
		push word [bootstrap.diskTransferBuffer + si + 2 ] ; 156 is the offset of the root directory
		push word [bootstrap.diskTransferBuffer + si + 4 ] ; 156 is the offset of the root directory
		pop word [bootstrap.DAP.lbaLow + 2] ; 2-4 little endian is the LBA location of extent root directory
		pop word [bootstrap.DAP.lbaLow]
		; Load disk data
		call bootstrap.loadDiskData

		; Print that we have successfully loading image data into our diskTransferBuffer
		mov si, bootstrap.msg.disk.succ
		call bootstrap.string.printString

		popa
		ret

	.notFound:
		; Let the user know that we have failed.
		mov si, bootstrap.msg.disk.error
		call bootstrap.string.printString
		jmp $

bootstrap.loadDiskData:

	pusha	
	; Make sure we are loading data in the right direction
	cld 	
	mov cx, 0x02    ; maximum attempts - 1
	.top:
		; Read sectors into memory (int 0x13, ah = 0x42)
		xor dx, dx
		mov dl, [bootstrap.bootDrive]
		mov si, bootstrap.DAP
		mov ah, 0x42
		int 0x13
		; Exit if read succeeded
		jnc .end

		; Decrement remaining attempts
		dec cx
		cmp cx, 0
		; Exit if maximum attempts exceeded
		je  .errorjc

		; Reset disk system (int 0x13, ah = 0x00)
		xor ah, ah
		int 0x13

		; retry if reset succeeded, otherwise exit
		jnc .top
	.end:
		popa
		retn
	
	.errorjc:
		mov si, bootstrap.msg.disk.error
		call bootstrap.string.printString
		jmp $

