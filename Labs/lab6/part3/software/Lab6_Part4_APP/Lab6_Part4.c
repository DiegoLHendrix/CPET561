#include "alt_types.h"
#include "io.h"
#include "sys/alt_irq.h"
#include "system.h"
#include <stdbool.h>
#include <stdio.h>

// create standard embedded type definitions
typedef signed char sint8;     // signed 8 bit values
typedef unsigned char uint8;   // unsigned 8 bit values
typedef signed short sint16;   // signed 16 bit values
typedef unsigned short uint16; // unsigned 16 bit values
typedef signed long sint32;    // signed 32 bit values
typedef unsigned long uint32;  // unsigned 32 bit values
typedef float real32;          // 32 bit real values

// peripherals pointers
uint32 *RAMptr = (uint32 *)INFERRED_RAM_BE_0_BASE;
uint32 *KEYptr = (uint32 *)KEY_BASE;
uint32 *LEDRptr = (uint32 *)LEDR_BASE;

uint32 ramTest8(uint8 *addr, uint32 ramSize, uint8 testData)
{
    for (uint32 i = 0; i < ramSize; i++)
    {
        addr[i] = testData;
    }

    for (uint32 i = 0; i < ramSize; i++)
    {
        if (addr[i] != testData)
        {
            printf("8 bit test: \nAddress: 0x%08X \nRead: 0x%02X \nExpected: 0x%02X \n", i, addr[i], testData);

            return 0xFF;
        }
    }
    return 0;
}

uint32 ramTest16(uint16 *addr, uint32 ramSize, uint16 testData)
{
    for (uint32 i = 0; i < (ramSize / 2); i++)
    {
        addr[i] = testData;
    }

    for (uint32 i = 0; i < (ramSize / 2); i++)
    {
        if (addr[i] != testData)
        {
            printf("16 bit test: \nAddress: 0x%08X \nRead: 0x%04X \nExpected: 0x%04X \n", i, addr[i], testData);

            return 0xFF;
        }
    }
    return 0;
}

uint32 ramTest32(uint32 *addr, uint32 ramSize, uint32 testData)
{
    for (uint32 i = 0; i < (ramSize / 4); i++)
    {
        addr[i] = testData;
    }

    for (uint32 i = 0; i < (ramSize / 4); i++)
    {
        if (addr[i] != testData)
        {
            printf("32 bit test: \nAddress: 0x%08X \nRead: 0x%08X \nExpected: 0x%08X \n", i, addr[i], testData);

            return 0xFF;
        }
    }
    return 0;
}

// Function to clear non-zero addresses
void clearRam(uint32 *addr, uint32 bytes)
{
    for (uint32 i = 0; i < bytes; i++)
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
    printf("Hello World!\n");
    clearRam((uint32 *)RAMptr, 1024);

    while (1)
    {
        *LEDRptr = ramTest8((uint8 *)RAMptr, 1024, 0x78);
        *LEDRptr = ramTest16((uint16 *)RAMptr, 1024, 0x5678);
        *LEDRptr = ramTest32((uint32 *)RAMptr, 1024, 0x12345678);
    }
    return 0;
}