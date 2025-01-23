#ifndef __SD_CARD_H__
#define __SD_CARD_H__
#include "config.h"

#ifdef __cplusplus
extern "C"
{
#endif // __cplusplus

    device_result_code_t SD_Init(void);
    device_result_code_t SD_GetCardInfo(void);
    device_result_code_t SD_GetCardState(void);
    device_result_code_t SD_ReadDisk(uint8_t *buf, uint32_t sector, uint32_t cnt);
    device_result_code_t SD_WriteDisk(uint8_t *buf, uint32_t sector, uint32_t cnt);
    device_result_code_t SD_ReadBlocks_DMA(uint32_t *buf, uint64_t sector, uint32_t blocksize, uint32_t cnt);
    device_result_code_t SD_WriteBlocks_DMA(uint32_t *buf, uint64_t sector, uint32_t blocksize, uint32_t cnt);

#ifdef __cplusplus
}
#endif // __cplusplus

#endif // __SD_CARD_H__