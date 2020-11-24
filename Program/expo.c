#include <stdio.h>


    int expo(int x, int n)
    {
        int r = 1;
        int i;
        for (i=0; i < n; i++)
        {
            r *= x;
        }
        return r;
    }
    
    int main()
    {
        int x, n;
        printf("Skriv in bastalet, sedan dess exponent:");
        scanf("%d %d", &x, &n);
        
        printf("%d\n", expo(x,n));
    }
