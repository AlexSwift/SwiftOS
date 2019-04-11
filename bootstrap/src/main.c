#include <stddef.h>
#include <stdbool.h>

#include "a20.h"
#include "kernel.h"
#include "string.h"
#include "memory.h"
#include "tty.h"
#include "multiboot.h"

const char *graphic = "\n\
          ,d88~~\\                ,e,   88~\\   d8     ,88~-_   ,d88~~\\          \n\
          8888    Y88b    e    /     _888__ _d88__  d888   \\  8888             \n\
          `Y88b    Y88b  d8b  /  888  888    888   88888    | `Y88b            \n\
           `Y88b,   Y888/Y88b/   888  888    888   88888    |  `Y88b,          \n\
             8888    Y8/  Y8/    888  888    888    Y888   /     8888          \n\
          \\__88P'     Y    Y     888  888     88_/   `88_-~   \\__88P'          \n\
             (c) 2019 - Robert Alexander Swift - Welcome to sBoot              \n\n";

void c_main(void){

	puts( graphic );
	puts( "[Bootstrap] Bootstrap Initialized!\n" );

	a20_enable();
	memory_initialize( );
	//kernel_load(  "KERNEL.BIN;1");

}

void abort(){
  while (1) { }
  __builtin_unreachable();
}