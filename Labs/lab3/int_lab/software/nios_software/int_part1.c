/* This is a C program written for the timer interrupt demo.  The 
 program assumes a nios_system with a periodic interrupt timer
 and an 8-bit output PIO named leds. */


/* alt_types.h and sys/alt_irq.h need to be included for the interrupt
  functions
  system.h is necessary for the system constants
  io.h has read and write functions */
#include "io.h"
#include <stdio.h>
#include "system.h"
#include "alt_types.h"
#include "sys/alt_irq.h"
#include "altera_avalon_timer_regs.h"
#include "altera_avalon_timer.h"

// create standard embedded type definitions
typedef   signed char   sint8;              // signed 8 bit values
typedef unsigned char   uint8;              // unsigned 8 bit values
typedef   signed short  sint16;             // signed 16 bit values
typedef unsigned short  uint16;             // unsigned 16 bit values
typedef   signed long   sint32;             // signed 32 bit values
typedef unsigned long   uint32;             // unsigned 32 bit values
typedef         float   real32;             // 32 bit real values

//set up pointers to peripherals

uint32* TimerPtr       = (uint32*)TIMER_0_BASE;
unsigned char* LedPtr  = (unsigned char*)LEDS_BASE;
unsigned char* Hex0Ptr = (unsigned char*)HEX0_BASE;
unsigned char* SWPtr   = (unsigned char*)SWITCHES_BASE;
uint32* KEYSPtr = (uint32*)KEYS_BASE;

// Array that stores the hex values for the seven segment display.
int arr[16] = { 0x40, 0x79, 0x24, 
				0x30, 0x19, 0x12, 
				0x02, 0x78, 0x00, 
				0x18, 0x08, 0x03, 
				0x46, 0x21, 0x06, 
				0x0E };

//Integer that holds the index of the array element to display.
// volatile int inc = 0;`

void timer_isr(void *context)
/*****************************************************************************/
/* Interrupt Service Routine                                                 */
/*   Determines what caused the interrupt and calls the appropriate          */
/*  subroutine.                                                              */
/*                                                                           */
/*****************************************************************************/
{
    unsigned char current_val;
    
    //clear timer interrupt
    *TimerPtr = 0;

    current_val = *LedPtr;    /* read the leds */
	
    *LedPtr  = current_val + 1;  /* change the display */
    return;
}

void key_isr(void *context){
	static int inc = 0; /*Integer that holds the index of the array element to display. */
	unsigned char sw_val;
    static unsigned char hex0_val = 0x40;
	sw_val  = (*SWPtr)&1;  /* read the switches */
	
	if(sw_val == 1) {
		inc++;
		if(inc > 9){
			inc = 0;
		}
		hex0_val = arr[inc];
	}
	else{
		inc--;
		if(inc < 0){
			inc = 9;
		}
		hex0_val = arr[inc];
	}
	
	*Hex0Ptr = hex0_val;
    sw_val   = 0;
	
	*(KEYSPtr+3) &= 0x02;
	return;
}

int main(void)
/*****************************************************************************/
/* Main Program                                                              */
/*   Enables interrupts then loops infinitely                                */
/*****************************************************************************/
{
	/* this enables the NIOS II to accept a TIMER interrupt 
     * and indicates the name of the interrupt handler */
	alt_ic_isr_register(TIMER_0_IRQ_INTERRUPT_CONTROLLER_ID,TIMER_0_IRQ,timer_isr,0,0);
	
	uint32 key_temp;
	
	*(KEYSPtr+2) |= 0x02;  /* Enable interrupt in bit 2 of key interrupt mask register */
	*(KEYSPtr+3) |= 0x02;
	
	key_temp	  = (*KEYSPtr+3)&2;
	
	alt_ic_isr_register(KEYS_IRQ_INTERRUPT_CONTROLLER_ID,KEYS_IRQ,key_isr,0,0);
	
	*LedPtr  = 0;	 /* initial value to leds */
	*Hex0Ptr = 0x40; /* initial value to hex0 */
	*SWPtr   = 0;	 /* initial value to switches */
		
    // while(1);
    return 0;
}
