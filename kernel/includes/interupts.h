#ifndef INTERUPTS_H
#define INTERUPTS_H

#define IRQ_MAX 236
#define IRQ_GETIRQ( number ) irq ## number
#define IRQ_HANDLER_EMPTY( number ) void irq ## number ## _handler(void){ \
	pic_sendEOI( number ); \
} 

extern int idt_load();
extern void * irq_list;

typedef struct{
	uint16_t offset_lowerbits;
	uint16_t selector;
	uint8_t zero;
	uint8_t type_attr;
	uint16_t offset_higherbits;
}__attribute__((packed)) idt_entry_t;

unsigned long idt_common_handler( unsigned long , unsigned long, unsigned long ); 
void interupts_init(void);

#endif