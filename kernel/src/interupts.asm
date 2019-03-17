bits    32
section .text

global idt_load
extern idt_common_handler

%macro interrupt_handler_error 1
global interrupt_handler_%1
interrupt_handler_%1:
  push dword %1             ; push the interrupt number
  call idt_common_handler   ; jump to the common handler
  add esp, 8
  iret
%endmacro

%macro interrupt_handler 1
global interrupt_handler_%1
interrupt_handler_%1:
  push dword 0                     ; push 0 as error code
  push dword %1                    ; push the interrupt number
  call idt_common_handler          ; jump to the common handler
  add esp, 8
  iret
%endmacro

%assign intnum 0
%rep 8 - intnum
    interrupt_handler intnum
    %assign intnum intnum + 1
%endrep

interrupt_handler_error 8
interrupt_handler 9

%assign intnum 10
%rep 13 - intnum
    interrupt_handler intnum
    %assign intnum intnum + 1
%endrep

interrupt_handler_error 13

%assign intnum 14
%rep 17 - intnum
    interrupt_handler intnum
    %assign intnum intnum + 1
%endrep

interrupt_handler_error 17
interrupt_handler 18
interrupt_handler 19
interrupt_handler 20

%assign intnum 21
%rep 32 - intnum
    interrupt_handler intnum
    %assign intnum intnum + 1
%endrep

%assign intnum 32
%rep 256 - intnum
    interrupt_handler intnum
    %assign intnum intnum + 1
%endrep

global irq_list
irq_list:
%assign intnum 0
%rep 256
    dd  interrupt_handler_ %+ intnum
    %assign intnum intnum + 1
%endrep

idt_load:
	mov edx, [esp + 4]
	lidt [edx]
	sti
	ret