#include "hw.h"
#include "serial.h"

void delay(uint32_t t)
{
    uint32_t tickstart = get_hw_count();
    uint32_t wait = t;

    /* Add a freq to guarantee minimum wait */
    if (wait < HAL_MAX_DELAY)
    {
        wait += 1;
    }

    while ((get_hw_count() - tickstart) < wait)
    {
    }
}

void hw()
{
    printf("[I]][HW] Hardware init...\n");
    delay_init();
    usart_init(0);
    while (1)
    {
        // printf("the current timestamp is %d\n", t);
        delay(100);
        HAL_GPIO_TogglePin(LED0_GPIO_Port, LED0_Pin);
    }
}
