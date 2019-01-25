;***************************************************************************
;
;						swiftOS v0.3: GDT Tables
;			with thanks to osdev.org and it's contributors
;***************************************************************************

;****************************************************
;		Segment references
;****************************************************
stage1.gdt:
.kernel_code		equ stage1.gdt.entry_kernel_code - stage1.gdt.entry_null
.kernel_data 		equ stage1.gdt.entry_kernel_data - stage1.gdt.entry_null
.kernel_stack	 	equ stage1.gdt.entry_kernel_stack - stage1.gdt.entry_null
;.stage2_video	 	equ stage1.gdt.entry_stage2_video8025 - stage1.gdt.entry_null

;****************************************************
;		GDT Data
;****************************************************

.gdt_start:
	.entry_null: 
		dd 0x0 
		dd 0x0
	;.gdt_stage1_code:
	;	dw 0xffff
	;	dw 0x0
	;	db 0x0
	;	db 10011010b
	;	db 11001111b
	;	db 0x0
	;.gdt_stage1_data: 
	;	dw 0xffff
	;	dw 0x0 
	;	db 0x0
	;	db 10010010b
	;	db 11001111b
	;	db 0x0
		
	.entry_kernel_code:
		dw 0x2000				;not sure what this limmit should be
		dw SWIFTOS_KERNEL_SEGMNT*16 + SWIFTOS_KERNEL_OFFSET
		db 0x0
		db 10011110b 			; access (P, RING(2) , 1, Ex, DC, RW)
		db 11000000b 			; granularity
		db 0x00
	.entry_kernel_data: 
		dw 0x2000
		dw SWIFTOS_KERNEL_SEGMNT*16 + SWIFTOS_KERNEL_OFFSET
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
	dd SWIFTOS_KERNEL_SEGMNT*16 + .gdt_start
	
;****************************************************
;		Load GDT into memory
;****************************************************

.load:

	push si
	push ax
	push dx

	mov si, stage1.msg.gdt.setup
	call stage1.printString

	lgdt [.gdt_desc]
	
	mov si, stage1.msg.done
	call stage1.printString
	
	pop dx
	pop ax
	pop si
	
	ret
