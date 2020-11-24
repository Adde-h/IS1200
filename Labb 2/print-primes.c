/*
 print-prime.c
 By David Broman.
 Last modified: 2015-09-15
 This file is in the public domain.
*/

//Written by Adeel Hussain

#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#define COLUMNS 6

int antaltal = 0;

int is_prime(int n)
{
  int primtal;
  int i = 2;

  for(i; i <= sqrt(n); i++)
  {
    if(n % i == 0)
    {
      primtal = 0;
      break;
    }
    else
    {
      primtal = 1;
    }
  }
  
  return primtal;
}
void print_number(int n)
{
  if(antaltal % COLUMNS == 0 && antaltal != 0)
  {
    printf("\n");
  }

  printf("%10d ", n);
  antaltal++;

}


void print_primes(int n){

  int i = 2;

  for(i; i <= n; i++)
  {
    if(is_prime(i))
    {
      print_number(i);
    }
  }

  printf("\n");
}



// 'argc' contains the number of program arguments, and
// 'argv' is an array of char pointers, where each
// char pointer points to a null-terminated string.
int main(int argc, char *argv[]){
  if(argc == 2)
    print_primes(atoi(argv[1]));
  else
    printf("Please state an interger number.\n");
  return 0;
}

 
