#include <stdio.h>

int main()
{
    char c;
    int lines = 0, words = 0; //int lines, words = 0;
    int chars, in_space = 1;
   
    while((c = getchar()) != EOF)
    {
        chars++;
        if(c == '\n') //if(c = '\n')
        lines++;
        if(c==' ' || c=='\t' || c == '\n') // if(c==' ' || c == '\n')
        in_space = 1;
        else         //Saknades måsvingar
        {
            words += in_space;
            in_space = 0;
        }

        printf("%8d%8d%8d\n", lines, words, chars);
        return 0;       


    }
}

