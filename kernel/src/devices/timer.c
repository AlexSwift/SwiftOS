#include "devices/timer.h"
#include "io.h"

#include <libk/stdio.h>

unsigned int timer_count;

void timer_initialize( void ){
	timer_count = 0;
}

void timer_interupt_handler( void ){

	timer_count++;

	//printf( "[Kernel] Timer count has reached: %d\n", timer_count);

}