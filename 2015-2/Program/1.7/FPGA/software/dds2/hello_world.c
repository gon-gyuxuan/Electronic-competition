/*
 * "Hello World" example.
 *
 * This example prints 'Hello from Nios II' to the STDOUT stream. It runs on
 * the Nios II 'standard', 'full_featured', 'fast', and 'low_cost' example
 * designs. It runs with or without the MicroC/OS-II RTOS and requires a STDOUT
 * device in your system's hardware.
 * The memory footprint of this hosted application is ~69 kbytes by default
 * using the standard reference design.
 *
 * For a reduced footprint version of this template, and an explanation of how
 * to reduce the memory footprint for a given application, see the
 * "small_hello_world" template.
 *
 */

#include <stdio.h>
#include "altera_avalon_pio_regs.h"
#include "altera_avalon_uart_regs.h"
#include "system.h"

char fore_txdata[6] = {'a','c','e','m','o'};
char latter_txdata[6] = {'b','d','f','n','p'};

void delay(int z)
{
	int x,y;
	for(x = z;x>0;x--)
	for(y = 110;y>0;y--);
}



int main()
{
  int dds_data;
  alt_u8 dds_data0;
  alt_u8 dds_data1;
  alt_u8 dds_data2;
  alt_u8 dds_data3;

  while(1)
  {
	  dds_data = IORD_ALTERA_AVALON_PIO_DATA(DDS_DATA_BASE);
//	  delay(10000);
//	  printf("dds_data = %d\n",dds_data);

	  dds_data0 = dds_data & 255;
	  dds_data1 = (dds_data >> 8) &255;
	  dds_data2 = (dds_data>>16) &255;
	  dds_data3 = (dds_data>>24) &255;

	  while(!(ALTERA_AVALON_UART_STATUS_TRDY_MSK & IORD_ALTERA_AVALON_UART_STATUS(UART_BASE)));
	  IOWR_ALTERA_AVALON_UART_TXDATA(UART_BASE, fore_txdata[0]);
	  while(!(ALTERA_AVALON_UART_STATUS_TRDY_MSK & IORD_ALTERA_AVALON_UART_STATUS(UART_BASE)));
	  	  IOWR_ALTERA_AVALON_UART_TXDATA(UART_BASE, dds_data0);
	  while(!(ALTERA_AVALON_UART_STATUS_TRDY_MSK & IORD_ALTERA_AVALON_UART_STATUS(UART_BASE)));
	  IOWR_ALTERA_AVALON_UART_TXDATA(UART_BASE, dds_data1);
	  while(!(ALTERA_AVALON_UART_STATUS_TRDY_MSK & IORD_ALTERA_AVALON_UART_STATUS(UART_BASE)));
	  IOWR_ALTERA_AVALON_UART_TXDATA(UART_BASE, dds_data2);
	  while(!(ALTERA_AVALON_UART_STATUS_TRDY_MSK & IORD_ALTERA_AVALON_UART_STATUS(UART_BASE)));
	  	  IOWR_ALTERA_AVALON_UART_TXDATA(UART_BASE, dds_data3);
	  while(!(ALTERA_AVALON_UART_STATUS_TRDY_MSK & IORD_ALTERA_AVALON_UART_STATUS(UART_BASE)));
	  IOWR_ALTERA_AVALON_UART_TXDATA(UART_BASE, latter_txdata[0]);
  }



  return 0;
}














