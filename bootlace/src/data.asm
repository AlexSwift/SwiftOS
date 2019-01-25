;***************************************************************************
;
;			swiftOS v0.4: Boot Sector Data
;			with thanks to osdev.org and it's contributors
;***************************************************************************


;****************************************************
;		Message Data
;****************************************************

bootlace.msg.prefix:		db	"[Bootstrap] ",0
bootlace.msg.disk.error:	db	"Disk read error!", 0
bootlace.msg.disk.succ:	db	"Disk read of Stage1 Successful!", 0

;****************************************************
;		Disk Data
;****************************************************

bootlace.bootDrive:		db	0

bootloader.DAP: db 10h,0 
.SectorsToRead:             dw SWIFTOS_BOOTSTRAP_SIZE		; Number of sectors to read (read size of OS) 
.Offset:                    dw SWIFTOS_BOOTSTRAP_OFFSET		; Offset :0000 
.Segment:                   dw SWIFTOS_BOOTSTRAP_SEGMNT		; Segment 0200
.End:                       dq SWIFTOS_BOOTSTRAP_SECTOR		; Sector 16 or 10h on CD-ROM 


