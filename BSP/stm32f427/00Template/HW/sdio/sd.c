#include "sd.h"

extern SD_HandleTypeDef hsd;   // SD卡句柄
HAL_SD_CardInfoTypeDef SdCard; // SD卡信息结构体

// SD卡初始化
device_result_code_t SD_Init()
{
    return SD_GetCardInfo();
}

device_result_code_t SD_GetCardInfo(void)
{
    if (HAL_SD_GetCardInfo(&hsd, &SdCard) != HAL_OK)
    {
        printf("[E][SD] Get card info failed\n");
        return DEVICE_GENERIC_ERROR;
    }
    uint64_t CardCap = (uint64_t)(SdCard.LogBlockNbr) * (uint64_t)(SdCard.LogBlockSize); // 计算SD卡容量
    printf("[I][SD] SD card info:\n");
    printf("[I][SD] Card type: %d\n", SdCard.CardType);
    printf("[I][SD] Card version: %d\n", SdCard.CardVersion);
    printf("[I][SD] Card class: %d\n", SdCard.Class);
    printf("[I][SD] Card block number: %d\n", SdCard.LogBlockNbr);
    printf("[I][SD] Card block size: %d\n", SdCard.LogBlockSize);
    printf("[I][SD] Card capacity: %dBytes\n", CardCap);
    printf("[I][SD] SD card info success\n");
    return DEVICE_SUCCESS;
}
device_result_code_t SD_GetCardState(void)
{
    return HAL_SD_GetCardState(&hsd) == HAL_SD_CARD_TRANSFER ? DEVICE_SUCCESS : DEVICE_IS_BUSY;
}

device_result_code_t SD_ReadDisk(uint8_t *buf, uint32_t sector, uint32_t cnt)
{
    uint32_t timeout = HAL_MAX_DELAY;
    __disable_irq(); // disable interrupt
    uint8_t res = HAL_SD_ReadBlocks(&hsd, buf, sector, cnt, timeout);
    if (res != HAL_OK)
    {
        printf("[E][SD] Read disk failed\n");
        __enable_irq();
        return DEVICE_GENERIC_ERROR;
    }
    do
    {
        res = SD_GetCardState();
        if (res == DEVICE_SUCCESS)
        {
            __enable_irq();
            return res;
        }
    } while (timeout-- != 0);
    __enable_irq(); // enable interrupt
    printf("[E][SD] Write disk timeout\n");
    return res;
}

device_result_code_t SD_WriteDisk(uint8_t *buf, uint32_t sector, uint32_t cnt)
{
    uint32_t timeout = HAL_MAX_DELAY;
    __disable_irq(); // disable interrupt
    uint8_t res = HAL_SD_WriteBlocks(&hsd, buf, sector, cnt, timeout);
    if (res != HAL_OK)
    {
        printf("[E][SD] Write disk failed\n");
        __enable_irq();
        return DEVICE_GENERIC_ERROR;
    }
    do
    {
        res = SD_GetCardState();
        if (res == DEVICE_SUCCESS)
        {
            __enable_irq();
            return res;
        }
    } while (timeout-- != 0);
    __enable_irq(); // enable interrupt
    printf("[E][SD] Write disk timeout\n");
    return res;
}

device_result_code_t SD_ReadBlocks_DMA(uint32_t *buf, uint64_t sector, uint32_t blocksize, uint32_t cnt)
{
    uint8_t res;
    uint32_t timeout = HAL_MAX_DELAY;
    res = HAL_SD_ReadBlocks_DMA(&hsd, (uint8_t *)buf, sector, cnt);
    if (res != HAL_OK)
    {
        printf("[E][SD] Read blocks DMA failed\n");
        return DEVICE_GENERIC_ERROR;
    }
    do
    {
        res = SD_GetCardState();
        if (res == DEVICE_SUCCESS)
        {
            return res;
        }
    } while (timeout-- != 0);
    printf("[E][SD] Read blocks DMA timeout\n");
    return res;
}
device_result_code_t SD_WriteBlocks_DMA(uint32_t *buf, uint64_t sector, uint32_t blocksize, uint32_t cnt)
{
    uint8_t res;
    uint32_t timeout = HAL_MAX_DELAY;
    res = HAL_SD_WriteBlocks_DMA(&hsd, (uint8_t *)buf, sector, cnt);
    if (res != HAL_OK)
    {
        printf("[E][SD] Write blocks DMA failed\n");
        return DEVICE_GENERIC_ERROR;
    }
    do
    {
        res = SD_GetCardState();
        if (res == DEVICE_SUCCESS)
        {
            return res;
        }
    } while (timeout-- != 0);
    printf("[E][SD] Write blocks DMA timeout\n");
    return res;
}