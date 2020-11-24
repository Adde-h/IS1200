#include <stdio.h>

void adder(const int *x, const int *y, int *z)
{
    *z = *x + *y;
}

int foo(int a)
{
    const int k = 10;
    const int *y = &k;
    const int *x = &a;

    int noll = 0;
    int *z = &noll;

    adder(x, y, z);
    return *z;

}

int main()
{
    printf("%d\n", foo(7));
    return 0;

}
