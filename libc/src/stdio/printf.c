#include <stdarg.h>
#include <libc/string.h>
#include <kernel/terminal.h>

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
						terminal_writestring( str );
						break;
					}
					case 'c' :{
						char a = (char)va_arg( parameters, int );
						terminal_putchar( a );
						break;
					}
					case 'd' :{
						terminal_writestring( "0x" );
						unsigned long number = va_arg( parameters, unsigned long);
						for (size_t i=0;i<2*sizeof(unsigned long);i++){
							unsigned long test = 0xF&(number>>((sizeof(unsigned long)*2-i-1)*4));
							char hex = test < 0x0A ? test  + '0' : test - 0x0A + 'A';
							terminal_putchar(hex);
						}
						break;
					}
				}
				format++;
				break;
			}
			case '\n' :{
				terminal_newline();
				format++;
				break;
			}
			default :{
				terminal_putchar( *format );
				format++;
				written++;
				break;
			}
		}

	}

	va_end( parameters );

	return written;
}