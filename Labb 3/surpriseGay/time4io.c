#include <stdint.h>
#include <pic32mx.h>
#include "mipslab.h" 
//define a compile-time constant for period
// 256 is for prescaling
// 10 ms is the time out period
#define TMR2PERIOD ((80000000 / 256) / 10)

int getsw( void ){

	int SW = (PORTD >> 8) & 0x000F;

	return SW;
}

int getbtns(void){

	int BTN = (PORTD >> 5) & 0x0007;

	return BTN;
}

// delalying every 100 ms
void delaymillis(){
	
	T2CON = 0x70; // setting the prescale
	TMR2 = 0; // reset timer to 0
	T2CONSET = 0x8000; // turn timer on, set bit 15 to 1
	PR2 = TMR2PERIOD;

	IFS(0) = 0; // clear overflow flag
	// wait until overflow flag is set
	// display uodate only occurs once complete
	while(!(IFS(0) & 0x100));
	
}