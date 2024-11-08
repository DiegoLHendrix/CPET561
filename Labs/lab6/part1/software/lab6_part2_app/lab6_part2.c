#include "alt_types.h"
#include "io.h"
#include "sys/alt_irq.h"
#include "system.h"
#include <stdbool.h>
#include <stdio.h>

// create standard embedded type definitions
typedef signed char sint8;	   // signed 8 bit values
typedef unsigned char uint8;   // unsigned 8 bit values
typedef signed short sint16;   // signed 16 bit values
typedef unsigned short uint16; // unsigned 16 bit values
typedef signed long sint32;	   // signed 32 bit values
typedef unsigned long uint32;  // unsigned 32 bit values
typedef float real32;		   // 32 bit real values

// peripherals pointers
uint32 *RAMptr = (uint32 *)INFERRED_RAM_0_BASE;
uint32 *KEYptr = (uint32 *)KEY_BASE;
uint32 *LEDRptr = (uint32 *)LEDR_BASE;

uint32 ramTest8(uint32 *addr, uint8 bytes, uint8 data)
{
	for (int i = 0; i < bytes; i++)
	{
		addr[i] = data;
	}

	for (int i = 0; i < bytes; i++)
	{
		if (addr[i] != data)
		{
			return 0xFF;
		}
	}
}

uint32 ramTest16(uint32 *addr, uint16 bytes, uint16 data)
{
	for (int i = 0; i < bytes; i++)
	{
		addr[i] = data;
	}

	for (int i = 0; i < bytes; i++)
	{
		if (addr[i] != data)
		{
			return 0xFF;
		}
	}
}

uint32 ramTest32(uint32 *addr, uint32 bytes, uint32 data)
{
	for (int i = 0; i < bytes; i++)
	{
		addr[i] = data;
	}

	for (int i = 0; i < bytes; i++)
	{
		if (addr[i] != data)
		{
			return 0xFF;
		}
	}
}

// Function to clear non-zero addresses
void clearRam(uint32 *addr, uint32 bytes)
{
	for (int i = 0; i < bytes; i++)
	{
		if (addr[i] != 0)
		{
			addr[i] = 0;
		}
	}
}

int main(void)
{
	*LEDRptr = 0x00;
	while (1)
	{
		clearRam((uint32 *)RAMptr, 1024);

		*LEDRptr = ramTest8((uint32 *)RAMptr, 1, 0x12);

		*LEDRptr = ramTest16((uint32 *)RAMptr, 2, 0x1234);

		// Perform the 32-bit test as an example
		*LEDRptr = ramTest32((uint32 *)RAMptr, 4, 0x12345678);
	}

	return 0;
}
