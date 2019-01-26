;***************************************************************************
;
;						swiftOS v0.5: OEM Tables
;			with thanks to osdev.org and it's contributors
;***************************************************************************

%ifdef SWIFTOS_OEM_ISO

	times 08h-($-$$) db 0 ; Allign to 8 bytes

bootstrap.OEM:
	.bi_PrimaryVolumeDescriptor:	DD  1    ; LBA of the Primary Volume Descriptor
	.bi_BootFileLocation:			DD  1    ; LBA of the Boot File
	.bi_BootFileLength:				DD  1    ; Length of the boot file in bytes
	.bi_Checksum:					DD  1    ; 32 bit checksum
	.bi_Reserved:					DB  40   ; Reserved 'for future standardization'
	
	times 40h-($-$$) db 0 ; Pad till end of predefined size
 
%elif SWIFTOS_OEM_FAT12 

	times 08h-($-$$) db 0 ; Allign to 8 bytes

bootstrap.OEM:
	.bpbBytesPerSector:  		DW 512
	.bpbSectorsPerCluster: 		DB 1
	.bpbReservedSectors: 		DW 1
	.bpbNumberOfFATs: 	    	DB 2
	.bpbRootEntries: 	    	DW 224
	.bpbTotalSectors: 	    	DW 2880
	.bpbMedia: 	            	DB 0xF0
	.bpbSectorsPerFAT: 	    	DW 9
	.bpbSectorsPerTrack: 		DW 18
	.bpbHeadsPerCylinder: 		DW 2
	.bpbHiddenSectors: 	    	DD 0
	.bpbTotalSectorsBig:     	DD 0
	.bsDriveNumber: 	        	DB 0
	.bsUnused: 	           		DB 0
	.bsExtBootSignature: 		DB 0x29
	.bsSerialNumber:	        	DD 0xa0a1a2a3
	.bsVolumeLabel: 	        	DB "SWIFT OS   "
	.bsFileSystem: 	        	DB "FAT12   "
	
	times 40h-($-$$) db 0 ; Pad till end of predefined size
	
%else

	%error "SWIFTOS_OEM_* not defined for any particular file system"
	
%endif
