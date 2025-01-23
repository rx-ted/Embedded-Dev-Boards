#include "hw.h"
#include "delay.h"
#include "demo.h"
#include "at24cxx.h"
#include "lv_port_disp.h"
#include "lv_port_indev.h"
#include "lv_demos.h"
#include "lvgl.h"
#include "gfx.h"
#include "touch.h"
#include "led.h"
#include "serial.h"
#include "w25qxx_demo.h"
#include "sd.h"

extern touch_dev_t tp;
extern SPI_HandleTypeDef hspi3;
extern SRAM_HandleTypeDef hsram3;
extern SD_HandleTypeDef hsd;

void hw()
{
    printf("[I]][HW] Hardware init...\n");

    delay_init();
    usart_init(0);
    // at24cxx_init();
    // w25qxx_demo();
    // sram_demo();
    uint8_t res;
    printf("[I][HW] SD card init...\n");

    // res = SD_Init();
    // if (res != DEVICE_SUCCESS)
    // {
    //     printf("[E][HW] SD card init failed\n");
    //     return;
    // }
    // uint8_t *buf;
    // res = SD_ReadDisk(buf, 0, 1);
    // if (res != DEVICE_SUCCESS)
    // {
    //     printf("[E][HW] SD card read failed\n");
    //     return;
    // }
    // printf("[I][HW] SD card read success\n");
    // printf("from sd get the buffer data:\n");
    // for (int i = 0; i < 512; i++)
    // {
    //     printf("%x ", buf[i]);
    // }
    // printf("\n");
    // free(buf);

    lv_init();
    lv_port_disp_init();
    lv_port_indev_init();
    lv_demo_widgets();
    // lv_demo_stress();
    // lv_demo_benchmark();
    // demo_run();
    while (1)
    {
        lv_task_handler(); // lvgl的事务处理
    }
}
