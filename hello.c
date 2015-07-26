#include <stdio.h>
#include <unistd.h>


int main(int argc, char *argv[])
{
    printf("HELLO WORLD!\n");

    printf("argv:\n");
    int i;
    for (i = 0; i < argc; ++i) {
        printf("[%d] = \"%s\"\n", i, argv[i]);
    }

    pause();
    return 0; 
}
