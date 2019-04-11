#ifndef _REGISTERS_H
#define _REGISTERS_H

#include <stdint.h>
#include <stddef.h>

enum registers_eflags {
	//FLAGS
	REGISTERS_EFLAGS_CF = 0x0001,
	REGISTERS_EFLAGS_RES01 = 0x00002,
	REGISTERS_EFLAGS_PF = 0x0004,
	REGISTERS_EFLAGS_RES02 = 0x0008,
	REGISTERS_EFLAGS_AF = 0x0010,
	REGISTERS_EFLAGS_RES03 = 0x0020,
	REGISTERS_EFLAGS_ZF = 0x0040,
	REGISTERS_EFLAGS_SF = 0x0080,
	REGISTERS_EFLAGS_TF = 0x0100,
	REGISTERS_EFLAGS_IF = 0x0200,
	REGISTERS_EFLAGS_DF = 0x0400,
	REGISTERS_EFLAGS_OF = 0x0800,
	REGISTERS_EFLAGS_IOPL = 0x3000,
	//
	REGISTERS_EFLAGS_NT = 0x4000,
	REGISTERS_EFLAGS_RES04 = 0x8000,

	// EFLAGS
	REGISTERS_EFLAGS_RF = 0x00010000,
	REGISTERS_EFLAGS_VM = 0x00020000,
	REGISTERS_EFLAGS_AC = 0x00040000,
	REGISTERS_EFLAGS_VIF = 0x00080000,
	REGISTERS_EFLAGS_VIP = 0x00100000,
	REGISTERS_EFLAGS_ID = 0x00200000,
	REGISTERS_EFLAGS_RES05 = 0xFFC00000
};

typedef struct registers {
	union {
		struct {
			uint32_t edi;
			uint32_t esi;
			uint32_t ebp;
			uint32_t esp; //This is a temporary value that points ...
			uint32_t ebx;
			uint32_t edx;
			uint32_t ecx;
			uint32_t eax; //... Here

			uint32_t _fsgs;
			uint32_t _dses;

			uint32_t eflags;
		};
		struct {
			uint16_t di, hdi;
			uint16_t si, hsi;
			uint16_t bp, hbp;
			uint16_t sp, hsp;
			uint16_t bx, hbx;
			uint16_t dx, hdx;
			uint16_t cx, hcx;
			uint16_t ax, hax;

			uint16_t gs;
			uint16_t fs;
			uint16_t es;
			uint16_t ds;

			uint16_t flags, hflags;
		};
		struct {
			uint8_t dil, dih, hdil, hdih;
			uint8_t sil, sih, hsil, hsih;
			uint8_t bpl, bph, hbpl, hbph;
			uint8_t spl, sph, hspl, hsph;
			uint8_t bl, bh, hbl, hbh;
			uint8_t dl, dh, hdl, hdh;
			uint8_t cl, ch, hcl, hch;
			uint8_t al, ah, hal, hah;
		};

	};
} registers_t;

void intcall( uint8_t int_vector , registers_t *ireg, registers_t *oreg );
void initregs( registers_t *reg );
void registers_echo( registers_t *reg );

static inline uint16_t ds( void ){
	return 0x0000;
}

static inline uint16_t es( void ){
	return 0x0000;
}

static inline uint16_t fs( void ){
	return 0x0000;
}

static inline uint16_t gs( void ){
	return 0x0000;
}

#endif