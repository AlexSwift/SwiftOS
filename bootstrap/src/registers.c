#include "registers.h"
#include "string.h"
#include "tty.h"

void initregs( registers_t *reg ){
	memset(reg, 0, sizeof(registers_t));
	reg->ds = ds();
	reg->es = es();
	reg->fs = fs();
	reg->gs = gs();
};

void registers_echo( registers_t *reg ){
	puts("-------Register Debug-------\n");
	printf("reg->edi=%d\n",reg->edi);
	printf("reg->esi=%d\n",reg->esi);
	printf("reg->ebp=%d\n",reg->ebp);
	printf("reg->esp=%d\n",reg->esp);
	printf("reg->ebx=%d\n",reg->ebx);
	printf("reg->edx=%d\n",reg->edx);
	printf("reg->ecx=%d\n",reg->ecx);
	printf("reg->eax=%d\n",reg->eax);

	printf("reg->_fsgs=%d\n",reg->_fsgs);
	printf("reg->_dses=%d\n",reg->_dses);

	printf("reg->eflags=%d\n",reg->eflags);
	puts("----------------------------\n");
};