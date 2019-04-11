;***************************************************************************
;
;						swiftOS v0.5: GDT Tables
;			with thanks to osdev.org and it's contributors
;***************************************************************************

;****************************************************
;		Segment references
;****************************************************
bootstrap.gdt:
.kernel_code		equ bootstrap.gdt.entry_kernel_code - bootstrap.gdt.entry_null
.kernel_data 		equ bootstrap.gdt.entry_kernel_data - bootstrap.gdt.entry_null
.kernel_stack	 	equ bootstrap.gdt.entry_kernel_stack - bootstrap.gdt.entry_null
;.stage2_video	 	equ bootstrap.gdt.entry_stage2_video8025 - bootstrap.gdt.entry_null

;****************************************************
;		GDT Data
;****************************************************

.gdt_start:
	.entry_null: 
		dd 0x0 
		dd 0x0
	;.gdt_bootstrap_code:
	;	dw 0xffff
	;	dw 0x0
	;	db 0x0
	;	db 10011010b
	;	db 11001111b
	;	db 0x0
	;.gdt_bootstrap_data: 
	;	dw 0xffff
	;	dw 0x0 
	;	db 0x0
	;	db 10010010b
	;	db 11001111b
	;	db 0x0
		
	.entry_kernel_code:
		;dw 0x2000				;not sure what this limmit should be
		;dw SWIFTOS_KERNEL_SEGMNT*16 + SWIFTOS_KERNEL_OFFSET
		dw 0xffff
		dw 0x0000
		db 0x0
		db 10011110b 			; access (P, RING(2) , 1, Ex, DC, RW)
		db 11000000b 			; granularity
		db 0x00
	.entry_kernel_data: 
		;dw 0x2000
		;dw SWIFTOS_KERNEL_SEGMNT*16 + SWIFTOS_KERNEL_OFFSET
		dw 0xffff
		dw 0x0000
		db 0x0
		db 10010010b			; access
		db 11000000b 			; granularity
		db 0x00
	.entry_kernel_stack: 
		dw 0x2000
		dw 0x7C00
		db 0x0
		db 10010110b
		db 11000000b 			; granularity
		db 0x00
	;.entry_stage2_video8025: 
	;	dw 4000					; 4000 bytes of video memory
	;	dw SWIFTOS_STAGE2_VIDEO_MEMORY_LOW
	;	db SWIFTOS_STAGE2_VIDEO_MEMORY_HIGH_1
	;	db 10010010b
	;	db 11000000b 			; granularity
	;	db SWIFTOS_STAGE2_VIDEO_MEMORY_HIGH_2
		
	;.gdt_k_code:
	;	dw 0xffff
	;	dw 0x0
	;	db 0x0
	;	db 10011010b
	;	db 11001111b
	;	db 0x0
	;.gdt_k_data: 
	;	dw 0xffff
	;	dw 0x0 
	;	db 0x0
	;	db 10010010b
	;	db 11001111b
	;	db 0x0
.gdt_end :

;****************************************************
;		GDT Descriptor
;****************************************************

.gdt_desc:
	dw .gdt_end - .gdt_start - 1
	dd SWIFTOS_BOOTSTRAP_SEGMNT*16 + .gdt_start
	
;****************************************************
;		Load GDT into memory
;****************************************************

.load:

	push si

	mov si, bootstrap.msg.gdt.setup
	call bootstrap.string.printString

	lgdt [.gdt_desc]
	
	mov si, bootstrap.msg.done
	call bootstrap.string.printString
	
	pop si
	
	ret
