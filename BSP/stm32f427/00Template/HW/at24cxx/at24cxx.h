#ifndef __24CXX_H
#define __24CXX_H

#include "config.h"

#define AT24C01 127
#define AT24C02 255
#define AT24C04 511
#define AT24C08 1023
#define AT24C16 2047
#define AT24C32 4095
#define AT24C64 8191
#define AT24C128 16383
#define AT24C256 32767

/* 开发板使用的是24C02，所以定义EE_TYPE为AT24C02 */
#define EE_TYPE AT24C02
#define AT24C_DEV_ADDR (0XA0) // 设备地址

void at24cxx_init(void);                                            /* 初始化IIC */
device_result_code_t at24cxx_check(void);                                /* 检查器件 */
void at24cxx_write(uint16_t addr, uint8_t *pbuf, uint16_t datalen); /* 从指定地址开始写入指定长度的数据 */
void at24cxx_read(uint16_t addr, uint8_t *pbuf, uint16_t datalen);  /* 从指定地址开始读出指定长度的数据 */

#endif
