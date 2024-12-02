/*
 * audio_recorder.c
 *
 *  Created on: November 12, 2024
 *      Author: Diego Lopez
 *  Based on audio_demo.c by jxciee
 */

#include "alt_types.h"
#include "altera_avalon_timer.h"
#include "altera_avalon_timer_regs.h"
#include "altera_up_avalon_audio.h"
#include "io.h"
#include "math.h"
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

// set up pointers to peripherals
uint16 *SdramPtr = (uint16 *)NEW_SDRAM_CONTROLLER_0_BASE;
uint32 *AudioPtr = (uint32 *)AUDIO_0_BASE;
uint32 *TimerPtr = (uint32 *)TIMER_0_BASE;
uint32 *PinPtr = (uint32 *)PIN_BASE;
uint32 *AudioVideoPtr = (uint32 *)AUDIO_AND_VIDEO_CONFIG_0_BASE;

uint16 *FilterPtr = (uint16 *)AUDIO_FILTER_IP_0_BASE;
uint32 *KEYPtr = (uint32 *)KEY_BASE;
volatile uint32 *SWPtr = (uint32 *)SW_BASE;
uint32 *LEDRPtr = (uint32 *)LEDR_BASE;

int main(void)
{
	alt_up_audio_dev *audio_dev;
	/* used for audio record/playback */
	unsigned int l_buf;
	unsigned int r_buf;

	// open the Audio port
	audio_dev = alt_up_audio_open_dev("/dev/Audio");
	if (audio_dev == NULL)
		printf("Error: could not open audio device \n");
	else
		printf("Opened audio device \n");

	/* read and echo audio data */
	while (1)
	{
		unsigned int fifospace = alt_up_audio_read_fifo_avail(audio_dev, ALT_UP_AUDIO_RIGHT);
		if (fifospace > 0) /* Check if data is available. */
		{
			/* Read audio buffer. */
			alt_up_audio_read_fifo(audio_dev, &(r_buf), 1, ALT_UP_AUDIO_RIGHT);
			alt_up_audio_read_fifo(audio_dev, &(l_buf), 1, ALT_UP_AUDIO_LEFT);

			/* Write audio buffer. */
			alt_up_audio_write_fifo(audio_dev, &(r_buf), 1, ALT_UP_AUDIO_RIGHT);
			alt_up_audio_write_fifo(audio_dev, &(l_buf), 1, ALT_UP_AUDIO_LEFT);
		}
	}
}
