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

int mytime = 0x5957;
int timeoutcount = 0;
int prime = 1234567;
char textstring[] = "text, more text, and even more text!";

/* Interrupt Service Routine */
void user_isr( void )
{

  if (IFS(0) & 0x100){
    IFSCLR(0) = 0x100;
    timeoutcount++;

    if (timeoutcount == 10){
      time2string(textstring, mytime);
      display_string(3,textstring);
      display_update();
      tick(&mytime);
      timeoutcount=0;
    }
  }

  if (IFS(0) & (1<<15)){ //INT3
    mytime += 3;
    IFSCLR(0)= (1<<15);
  }

}


/* Lab-specific initialization goes here */
void labinit( void )
{
  T2CON |= 0x70;   // prescale
  PR2 = (80000000/256) / 10; // period på 10dels sekund
  TMR2 =0;
  T2CON |= 0x8000;  // sätta på timer
  IEC(0) |= 0x100;  // sätta på IEC, T2
  IPC(2) |= 0x4;    // Prioriteringslista, T2

  IEC(0) |= 0x800;  // sätta på IEC, INT3
  IPC(3) |= 0x1c000000;    // Prioriteringslista, 111 on bit 26-28 (0001 1100 0000 0000 0000 0000 0000 0000)


//  int sw = getsw()& 2;
enable_interrupt();
return;
}

/* This function is called repetitively from the main program */
void labwork( void )
{

 prime = nextprime(prime);
 time2string(textstring, mytime);
 display_string (0, itoaconv(prime));
 display_update();


}
