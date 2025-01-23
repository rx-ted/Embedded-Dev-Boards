#include "sram_demo.h"
#include "gfx.h"
#include <lcd.h>
#include <stm32f4xx_hal_sram.h>

extern SRAM_HandleTypeDef hsram3;

void sram_demo()
{
    gfx_init();
    show_string(15, 0 * 20 + 20, 200, 16, "GD32F427", GFX_FONT_16, RED);
    show_string(15, 1 * 20 + 20, 200, 16, "SRAM TEST", GFX_FONT_16, RED);

    HAL_SRAM_StateTypeDef res = HAL_SRAM_GetState(&hsram3);
    if (res != HAL_SRAM_STATE_READY) // SRAM未就绪
    {
        printf("ERR: sram status %d\n", res);
    }
    uint32_t p_addr = SRAM_BASE_ADDR;
    uint8_t str[] = "Hello Sram!\n";

    HAL_StatusTypeDef res1 = HAL_SRAM_Write_8b(&hsram3, (uint32_t *)p_addr, str, sizeof(str));
    if (res1 != HAL_OK)
    {
        printf("ERR: write sram failed %d\n", res1);
        return;
    }
    printf("INFO: write sram success\n");

    p_addr = SRAM_BASE_ADDR + sizeof(str);

    printf("INFO: read sram from %08x to %08x\n", SRAM_BASE_ADDR, p_addr);

    uint8_t tmp_str[64];

    res1 = HAL_SRAM_Read_8b(&hsram3, (uint32_t *)SRAM_BASE_ADDR, (uint8_t *)tmp_str, 64);
    if (res1 != HAL_OK)
    {
        show_string(15, 5 * 20 + 20, 200, 16, "Read sram: failed", GFX_FONT_16, RED);
        return;
    }
    printf("INFO: read sram success\n");
    printf("INFO: sram data: %s\n", tmp_str);
    if (strcmp(tmp_str, str) == 0)
    {
        printf("0K\n");
    }
}
