#include <stdio.h>
#include <unistd.h>
#include <sys/reboot.h>


int main(int argc, char *argv[])
{
    int rc;

    printf("HELLO WORLD!\n");

    printf("argv:\n");
    for (int i = 0; i < argc; ++i) {
        printf("[%d] = \"%s\"\n", i, argv[i]);
    }

    sync();
    rc = reboot(RB_POWER_OFF);
    if (rc) {
        printf("reboot() returned %d\n", rc);
    }

    pause();

    return 0; 
}
