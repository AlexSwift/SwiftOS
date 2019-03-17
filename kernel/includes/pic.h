#ifndef PIC_H
#define PIC_H

void pic_remap( int pci_master_offset, int pci_slave_offset );
void pic_sendEOI(unsigned char irq);

#endif