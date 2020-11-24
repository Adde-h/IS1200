/* mipslabwork.c

   This file written 2015 by F Lundevall
   Updated 2017-04-21 by F Lundevall

   This file should be changed by YOU! So you must
   add comment(s) here with your name(s) and date(s):

   This file modified 2017-04-31 by Ture Teknolog 

   For copyright and licensing, see file COPYING */

#include <stdint.h>   /* Declarations of uint_32 and the like */
#include <pic32mx.h>  /* Declarations of system-specific addresses etc */
#include "mipslab.h"  /* Declatations for these labs */

#define TMR2PERIOD ((80000000/256/10)) //100ms

int mytime = 0x0000;
int timeoutcount = 0;

char textstring[] = "text, more text, and even more text!";

/* Interrupt Service Routine */
void user_isr( void )
{
  return;
}

/* Lab-specific initialization goes here */
void labinit( void )
{
  
	// Set *E to address of TRISE.
	volatile int *E = (volatile int *) 0xbf886100;
	
	// Set first 8 bits to zero, i.e. sets them as output pins.
	*E = *E & 0xff00;

	// Initialize port D, set bits 11-5 as inputs.
	TRISD = TRISD & 0x0fe0;

	T2CONSET = 0x70; // 0111 0000 (bit 6-4 for prescaling, Section 14 Timers, P.9)
	PR2 = TMR2PERIOD; //Set the time period
	TMR2 = 0; //Resets the timer
	T2CONSET = 0x8000; //Sets the bit 15 "ON" to 1 in T2CON
  return;
}

/* This function is called repetitively from the main program */
void labwork( void )
{

	int sw = getsw();
	int btn = getbtns();

/*
Checks if bit 1(001) is pressed and 2(010) and so on ..	
	sw is a number 0-f, shift it into the right position and OR it with the correct zeroed byte of mytime.
	*/	

	//Button 2
	if (btn & 1) {
		mytime = (sw << 4) | (mytime & 0xff0f); //Shifts the sw information and stores them on the "tenth second" mark
	}
	//Button 3
	if (btn & 2) {
		mytime = (sw << 8) | (mytime & 0xf0ff);
	}
	//Button 4
	if (btn & 4) {
		mytime = (sw << 12) | (mytime & 0x0fff);
	}


 // delay( 1000 );

 if(IFS(0) & 0x100)
 {
	 IFS(0) = 0; //Reset Flags
	 timeoutcount++;

	 if(timeoutcount == 10)
	 {
		time2string( textstring, mytime );
		display_string( 3, textstring );
		display_update();
		tick( &mytime );
		display_image(96, icon);

		timeoutcount = 0;
	 }
 }

}
