;***************************************************************************
;
;			swiftOS v0.3: Stage1 Data
;			with thanks to osdev.org and it's contributors
;***************************************************************************

;****************************************************
;		String Data
;****************************************************

stage1.msg.prefix:		db "[Stage1] ",0
stage1.msg.doPrefix:	db 0
stage1.msg.hexPrefix:	db "0x"
stage1.msg.hexLoopup:	db "0123456789ABCDEF"

; Stage1 specific messages

stage1.msg.init:		db	"Stage1 Initialized!",0
stage1.msg.done:		db	"          > Done",0
stage1.msg.procPre:		db	"Attempting to boot into 32-bit mode!",0

; Stage2 specific messages
stage1.msg.loadStage2:	db	"Loading Stage2 into memory",0
stage1.msg.keyWait:		db	"Press any key to boot Stage2",0
stage1.msg.stage2Init:	db	"Initiating Stage2",0

; Disk messages

stage1.msg.disk.error:	db	"Disk read error!", 0
stage1.msg.disk.succ:	db	"Disk read of Stage2 Successful!", 0

; A20 messages

stage1.msg.a20.enable:	db "Enabling a20 memory lane...",0
stage1.msg.a20.nosupp:	db "Error: A20 disabled! Function not supported",0
stage1.msg.a20.secmode:	db "Error: A20 disabled! KC in Secure mode",0

; GDT messages

stage1.msg.gdt.setup:	db "Setting up GDT Table",0

; E820 messages

stage1.msg.e820.fetchMap:	db "Attempting to fetch e820 memory map",0
stage1.msg.e820.nosupp:		db "Error: e820 function not supported",0

;****************************************************
;		Video Data
;****************************************************

stage1.video.x:			db 0
stage1.video.y:			db 0

;****************************************************
;		Disk Data
;****************************************************

stage1.bootDrive:	db	0
stage1.DAP: 		db	10h,0 
	.SectorsToRead:	dw	SWIFTOS_KERNEL_SIZE		; Number of sectors to read (read size of OS) 
	.Offset:		dw	SWIFTOS_KERNEL_OFFSET		; Offset :0000 
	.Segment:		dw	SWIFTOS_KERNEL_SEGMNT		; Segment 0200
	.End:			dq	SWIFTOS_KERNEL_SECTOR		; Sector 16 or 10h on CD-ROM

;****************************************************
;		E820 Data
;****************************************************

stage1.e820.entries:	db 0
stage1.e820.data:		resb 200			; This shouldn't be here, more like finding a good place for it

;****************************************************
;		Stage1 Graphic Data
;****************************************************

stage1.graphic:
;db "                                                                                "
;db "         //   ) )                     //  ) )            //   ) ) //   ) )      "
;db "        ((                     ( ) __//__  __  ___      //   / / ((             "
;db "          \\     //  / /  / / / /   //      / /        //   / /    \\           "
;db "            ) ) //  / /  / / / /   //      / /        //   / /       ) )        "
;db "     ((___ / / ((__( (__/ / / /   //      / /        ((___/ / ((___ / /         "
;db "            (c) 2019 - Robert Alexander Swift - Welcome to Stage1               "
;db "                                                                               ",0

stage1.graphic2:
db "          ,d88~~\                ,e,   88~\   d8     ,88~-_   ,d88~~\           "
db "          8888    Y88b    e    /     _888__ _d88__  d888   \  8888              "
db "          `Y88b    Y88b  d8b  /  888  888    888   88888    | `Y88b             "
db "           `Y88b,   Y888/Y88b/   888  888    888   88888    |  `Y88b,           "
db "             8888    Y8/  Y8/    888  888    888    Y888   /     8888           "
db "          \__88P'     Y    Y     888  888     88_/   `88_-~   \__88P'           "
db "             (c) 2019 - Robert Alexander Swift - Welcome to Stage1              "
db "                                                                               ",0


;****************************************************
;		Test Data
;****************************************************

stage1.test:		dw 0