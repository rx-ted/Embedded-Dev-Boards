#ifndef __CONFIG_H__
#define __CONFIG_H__

#define STM32F103C8T6_VERSION "1.0"

#include <main.h>
#include <math.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <stm32f4xx.h>
#include <string.h>

#define LEDn 2U

#define SERIALx 1U
#define SERIAL1 USART1

#define LCD_DATA_BITS 16

#define BSP_USING_TOUCH 1
#define BSP_USING_LVGL 1

#define SYSTEM_SUPPORT_OS 0  // 定义系统文件夹是否支持OS

typedef enum {
  DEVICE_SUCCESS = 0x00,               // 无错误，操作成功
  DEVICE_GENERIC_ERROR = 1 << 0,       // 发生一般错误
  DEVICE_INVALID_ARG = 1 << 1,         // 参数无效
  DEVICE_NOT_PRESENT = 1 << 2,         // 设备未找到
  DEVICE_IS_BUSY = 1 << 3,             // 设备正忙
  DEVICE_OPERATION_TIMEOUT = 1 << 4,   // 操作超时
  DEVICE_OPERATION_CONTINUE = 1 << 5,  // 操作需继续
  DEVICE_UNINITIALIZED = 1 << 6,       // 设备未初始化
  DEVICE_NO_FURTHER_ACTION = 1 << 7,   // 不需要继续操作
  DEVICE_MEMORY_ALLOC_FAILED = 1 << 8,  // 申请空间失败，可能溢出或内存不够
} device_result_code_t;

typedef enum {
  DEVICE_ON = 1,
  DEVICE_OFF = 0,
} device_state_t;

#endif  // __CONFIG_H__
