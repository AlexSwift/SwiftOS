;***************************************************************************
;
;			swiftOS v0.5: Stage1 Data
;			with thanks to osdev.org and it's contributors
;***************************************************************************

;****************************************************
;		String Data
;****************************************************

bootstrap.msg.prefix:		db "[Bootstrap] ",0
bootstrap.msg.doPrefix:		db 0
bootstrap.msg.hexPrefix:	db "0x"
bootstrap.msg.hexLoopup:	db "0123456789ABCDEF"

; Stage1 specific messages

bootstrap.msg.init:			db "Bootstrap Initialized!",0
bootstrap.msg.done:			db "          > Done",0
bootstrap.msg.procPre:		db "Attempting to boot into 32-bit mode!",0

; Stage2 specific messages
bootstrap.msg.loadKernel:	db "Loading KERNEL.BIN into memory",0
bootstrap.msg.keyWait:		db "Press any key to boot Kernel",0
bootstrap.msg.kernelInit:	db "Initiating Kernel environment",0

; Disk messages

bootstrap.msg.disk.error:	db "Disk read error!", 0
bootstrap.msg.disk.succ:	db "Disk read of Kernel Successful!", 0

; A20 messages

bootstrap.msg.a20.enable:	db "Enabling a20 memory lane...",0
bootstrap.msg.a20.nosupp:	db "Error: A20 disabled! Function not supported",0
bootstrap.msg.a20.secmode:	db "Error: A20 disabled! KC in Secure mode",0

; GDT messages

bootstrap.msg.gdt.setup:	db "Setting up GDT Table",0

; E820 messages

bootstrap.msg.e820.fetchMap:	db "Attempting to fetch e820 memory map",0
bootstrap.msg.e820.nosupp:		db "Error: e820 function not supported",0

; Kernel module name

bootstrap.msg.kernel.name:		db "KERNEL.BIN;1"
bootstrap.msg.kernel.length:	db (bootstrap.msg.kernel.length-bootstrap.msg.kernel.name)

;****************************************************
;		Video Data
;****************************************************

bootstrap.video.x:			db 0
bootstrap.video.y:			db 0

;****************************************************
;		E820 Data
;****************************************************

bootstrap.e820.entries:		db 0
bootstrap.e820.data:		times 200 db 0		; This shouldn't be here, more like finding a good place for it

;****************************************************
;		Stage1 Graphic Data
;****************************************************

bootstrap.graphic:
db "          ,d88~~\                ,e,   88~\   d8     ,88~-_   ,d88~~\           "
db "          8888    Y88b    e    /     _888__ _d88__  d888   \  8888              "
db "          `Y88b    Y88b  d8b  /  888  888    888   88888    | `Y88b             "
db "           `Y88b,   Y888/Y88b/   888  888    888   88888    |  `Y88b,           "
db "             8888    Y8/  Y8/    888  888    888    Y888   /     8888           "
db "          \__88P'     Y    Y     888  888     88_/   `88_-~   \__88P'           "
db "             (c) 2019 - Robert Alexander Swift - Welcome to Stage1              "
db "                                                                               ",0

;****************************************************
;		Disk Data
;****************************************************

bootstrap.bootDrive:	db	0
bootstrap.sectorLength: dw	0
align 4
bootstrap.DAP: 			db	10h,0 
	.SectorsToRead:		dw	1								; Number of sectors to read (read size of OS) 
	.Offset:			dw	bootstrap.diskTransferBuffer	; Offset :0000 
	.Segment:			dw	SWIFTOS_BOOTSTRAP_SEGMNT		; Segment 0200
	.lbaLow:			dd	0								; Sector 16 or 10h on CD-ROM
	.lbaHigh:			dd	0

bootstrap.diskTransferBufferAddr:	dw bootstrap.diskTransferBuffer
align 16
bootstrap.diskTransferBuffer:	times 2048 db 0