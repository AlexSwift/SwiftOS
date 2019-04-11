#include <stdbool.h>
#include <stdarg.h>

#include "tty.h"
#include "registers.h"

void putChar( char letter ){

	if(letter == '\n') putChar('\r');

	registers_t reg;

	initregs( &reg );

	reg.bl = 0x0e;
	reg.ah = 0x0e;
	reg.al = letter;

	intcall( 0x10, &reg, &reg );

}

void puts( const char * str ){

	while( *str ){
		putChar(*str);
		str++;
	}

};

int printf( const char format[], ...){
	int written = 0;

	va_list parameters;
	va_start(parameters, format);

	while (*format != '\0'){
		switch (*format){
			case '%' :{
				format++;
				switch (*format){
					case 's' :{
						char *str = va_arg( parameters, char *);
						puts( str );
						break;
					}
					case 'c' :{
						char a = (char)va_arg( parameters, int );
						putChar( a );
						break;
					}
					case 'd' :{
						puts( "0x" );
						unsigned long number = va_arg( parameters, unsigned long);
						for (size_t i=0;i<2*sizeof(unsigned long);i++){
							unsigned long test = 0xF&(number>>((sizeof(unsigned long)*2-i-1)*4));
							char hex = test < 0x0A ? test  + '0' : test - 0x0A + 'A';
							putChar(hex);
						}
						break;
					}
					case 'l' :{
						format++;
						if(*format=='x'){
							puts( "0x" );
							uint64_t number = va_arg( parameters, uint64_t);
							for (size_t i=0;i<2*sizeof(uint64_t);i++){
								char offset = 0xF&(number>>((sizeof(uint64_t)*2-i-1)*4));
								char hex = offset < 0x0A ? offset + '0' : offset - 0x0A + 'A';
								putChar(hex);
							}
							break;
						}
					}
				}
				format++;
				break;
			}
			case '\n' :{
				putChar('\n');
				format++;
				break;
			}
			default :{
				putChar( *format );
				format++;
				written++;
				break;
			}
		}

	}

	va_end( parameters );

	return written;
}