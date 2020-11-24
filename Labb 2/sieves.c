#include <stdio.h>
#include <math.h>
#include <stdlib.h>
//Written by Adeel Hussain


#define COLUMNS 6

int antaltal = 0;
void print_number(int n)
{
  if(antaltal % COLUMNS == 0 && antaltal != 0)
  {
    printf("\n");
  }

  printf("%10d ", n);
  antaltal++;
}

void print_sieves(int n)
{
    int i;
    int j;
    char nummer[n];

    for(i = 0; i <= n; i++)
    {
       nummer[i] = 1;
    }

    for(i = 2; i <= (int) sqrt(n); i++)
    {
        if (nummer[i])
        {
            for(j = i*i; j < n; j+= i)
            {
                nummer[j] = 0;
            }
        }
    }

    for(i = 2; i < n; i++)
    {
        if((int) nummer[i])
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
		print_sieves(atoi(argv[1]));
	else
		printf("Please state an interger number.\n");
	return 0;
}