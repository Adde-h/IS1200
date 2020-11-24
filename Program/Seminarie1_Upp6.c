  
#include <stdio.h>

// Squares every element from the in array 
// and reverses the output in out array
void square_reverse(const double *x, double *y, const int len){
    int i;
    for(i = 0; i < len; i++)
        {*(y+len-i-1) = *(x+i) * *(x+i);}
}

// Declares in and out array length of 3,
// calls the square reverse and prints the result.
int main(){
    double in[] = {11.0, 20.0, 100.0}; 
    double out[3];
    int len = sizeof(out)/sizeof(double);
    square_reverse(in, out, len);
    printf("size of array: %d ", len);
    int i;
    for(i = 0; i < len; i++){
        printf("Index: %d Value: %f ", i, out[i]);
    }
    return 0;
}