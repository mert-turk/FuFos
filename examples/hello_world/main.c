#include "xil_printf.h"

int main(void)
{
    for (;;)
    {
        xil_printf("Hello World from FuFoS!\r\n");

        for (volatile unsigned int i = 0; i < 10000000U; i++)
        {
        }
    }
}