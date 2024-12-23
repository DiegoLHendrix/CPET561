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
uint32 *SWPtr = (uint32 *)SWITCHES_BASE;
uint32 *KEYSPtr = (uint32 *)KEYS_BASE;
uint32 *Hex0Ptr = (uint32 *)HEX0_BASE;
uint32 *Hex1Ptr = (uint32 *)HEX1_BASE;
uint32 *Hex2Ptr = (uint32 *)HEX2_BASE;
uint32 *Hex4Ptr = (uint32 *)HEX4_BASE;
uint32 *Hex5Ptr = (uint32 *)HEX5_BASE;
uint32 *ServoPtr = (uint32 *)SERVO_IP_0_BASE;

uint8 Hex[16] = {0x40, 0x79, 0x24, 0x30, 0x19, 0x12, 0x02, 0x78, 0x00, 0x18, 0x08, 0x03, 0x46, 0x21, 0x06, 0x0E};

int key2 = 0;
int key3 = 0;

// Servo values
uint32 min_val1 = 45;
uint32 min_val2 = 45 * (5000 / 9) + 25000;
uint32 max_val1 = 135;
uint32 max_val2 = 135 * (5000 / 9) + 25000;

void servo_isr(void *context)
{
  *(ServoPtr) = max_val2;
  *(ServoPtr + 1) = min_val2;
  return;
}

void keys_isr(void *context)
{
  // Check which key was pressed
  if (*(KEYSPtr + 3) == 0x04)
  {
    key2 = 1;
  }
  else if (*(KEYSPtr + 3) == 0x08)
  {
    key3 = 1;
  }

  // clear the interrupt
  *(KEYSPtr + 3) &= 0x0C;

  return;
}

int main(void)
{
  // Initialize ISRs
  alt_ic_isr_register(SERVO_IP_0_IRQ_INTERRUPT_CONTROLLER_ID, SERVO_IP_0_IRQ, servo_isr, 0, 0);
  alt_ic_isr_register(KEYS_IRQ_INTERRUPT_CONTROLLER_ID, KEYS_IRQ, keys_isr, 0, 0);

  // Set hex displays to be 0
  *Hex0Ptr = Hex[0];
  *Hex1Ptr = Hex[0];
  *Hex2Ptr = Hex[0];
  *Hex4Ptr = Hex[0];
  *Hex5Ptr = Hex[0];

  // Enable interrupts
  *(KEYSPtr + 2) |= 0x0C;

  // Switch vars
  uint32 sw_val;

  while (1)
  {

    if (key2 == 1)
    {
      // Read switches for min value
      sw_val = (*SWPtr);
      min_val1 = sw_val;
      min_val2 = sw_val * (5000 / 9) + 25000;
      key2 = 0;
    }
    else if (key3 == 1)
    {
      // Read switches for max value
      sw_val = (*SWPtr);
      max_val1 = sw_val;
      max_val2 = sw_val * (5000 / 9) + 25000;
      key3 = 0;
    }

    // Update HEX displays with current angles
    // Max val
    *Hex0Ptr = Hex[max_val1 % 10];         // Ones
    *Hex1Ptr = Hex[(max_val1 / 10) % 10];  // Tens
    *Hex2Ptr = Hex[(max_val1 / 100) % 10]; // Hundreds

    // Min val
    *Hex4Ptr = Hex[min_val1 % 10]; // Ones
    *Hex5Ptr = Hex[min_val1 / 10]; // Tens
  }
}

// var1 = var2
// 45 = 50k
// 135 = 100k
