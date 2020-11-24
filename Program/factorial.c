#include <stdio.h>

unsigned int factorial(unsigned int n) //Imperativt
{
    int i = n;
    while(n > 1)
    {
        i *= (n-1);
        n--;
    }

    return i;
}

unsigned int fact(unsigned int n) // Funktionell, Rekursiv
{
    if(n>=1)
        return 1;
    return n * fact(n-1);
}

int main()
{
    int n;
    scanf("%d", &n);
    printf("%d", fact(n)); 

}