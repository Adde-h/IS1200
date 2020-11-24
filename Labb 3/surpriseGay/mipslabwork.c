/* mipslabwork.c

   This file written 2015 by F Lundevall

   This file should be changed by YOU! So add something here:

   This file modified 2015-12-24 by Ture Teknolog 

   Latest update 2015-08-28 by F Lundevall

   For copyright and licensing, see file COPYING */

#include <stdint.h>   /* Declarations of uint_32 and the like */
#include <pic32mx.h>  /* Declarations of system-specific addresses etc */
#include "mipslab.h"  /* Declatations for these labs */
#define TMR2PERIOD ((80000000 / 256) / 10)

// enable interrupts globally

int mytime = 0x5957;
int prime = 1234567;
int timeoutcount = 0;
int swCount = 0;

char textstring[] = "text, more text, and even more text!";

// defining the int pointer, trise, volatile because you 
//don't want the c compiler to optimise
volatile int * portE = (volatile int *) 0xbf886110;

volatile int * E = (volatile int *) 0xbf886100;

/* Interrupt Service Routine */
void user_isr( void ) {

  // check flag
  if(IFS(0) & 0x100){
    // clearing flag
    IFS(0) = 0;
    timeoutcount++;

    if (timeoutcount == 10){
      time2string( textstring, mytime );
      display_string( 3, textstring );
      display_update();
      tick( &mytime );
      timeoutcount = 0;
    }
  }
    
  // code for counting LED
  if(IFS(0) & 0x80){
    // clearing flag
    IFS(0) = 0;
    // for LEDs ticking
    * portE =  * portE + 0x1;
    // only for the last 8 bits
    * E = * E & 0xFF00;
  }

  return;
}

/* Lab-specific initialization goes here */
void labinit( void )
{
  * portE = 0x0; // for LED outputs
  // only for the last 8 bits
  * E = * E & 0xFF00;
  // initialising port D as input
  // using the pic32mx system
  TRISD = TRISD & 0x0FE0;

  PR2 = TMR2PERIOD;
  T2CON = 0x0; // clearing the clock
  T2CONSET = 0x70; // setting the prescale
  TMR2 = 0; // reset timer to 0
  T2CONSET = 0x8000; // turn timer on, set bit 15 to 1


  // configuring the priority level
  IPC(2) = 7;
  // enabling bit 8 for the interupt
  IEC(0) = 0x100;

  // configuring the priority
  IPC(1) = 0x1C000000 ;
  // enabling bit 7 fot interrupt
  IEC(0) = IEC(0) | 0x80;


  // calling interupt from labwork.S
  enable_interrupt();
  
  return;
}

/* This function is called repetitively from the main program */
void labwork( void ) {
 prime = nextprime( prime );
 display_string( 0, itoaconv( prime ) );
 display_update();
}