#include"driver_ssd1306.h"

#include "driver_ssd1306_fonts.h"
#include "hw.h"
#include "serial.h"

extern I2C_HandleTypeDef hi2c1;

void hw() {
  printf("[I]][HW] Hardware init...\n");
  delay_init();
  usart_init(0);

  // driver_ssd1306_BasicInit(128, 64, IIC);
  driver_ssd1306_TestAll();
  while (1) {
    HAL_GPIO_TogglePin(LED0_GPIO_Port, LED0_Pin);
    driver_ssd1306_Fill(Black);
    driver_ssd1306_UpdateScreen();
    delay_ms(500);
    HAL_GPIO_TogglePin(LED0_GPIO_Port, LED0_Pin);
    driver_ssd1306_Fill(White);
    driver_ssd1306_UpdateScreen();
    delay_ms(500);
  }
}
