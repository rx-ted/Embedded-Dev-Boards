#ifndef __CONFIG_H__
#define __CONFIG_H__

#define STM32F103C8T6_VERSION "1.0"

#include "main.h"
#include <stm32f1xx.h>

#include <stdint.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "stdbool.h"

#ifndef DEBUG
#define DEBUG
#endif

#define LEDn 1U

#define SERIALx 1U
#define SERIAL1 USART1

#define SYSTEM_SUPPORT_OS 0 // 定义系统文件夹是否支持OS

typedef enum
{
    DEVICE_EOK = 0,   // 没有错误
    DEVICE_ERROR,     // 错误
    DEVICE_EINVAL,    // 非法参数
    DEVICE_NOT_FOUND, // 未找到
    DEVICE_EBUSY,     // 忙
    DEVICE_TIMEOUT,   // 超时
    DEVICE_CONTINUE,  // 继续
} device_result_t;

typedef enum
{
    DEVICE_ON = 1,
    DEVICE_OFF = 0,
} device_state_t;

#endif // __CONFIG_H__
