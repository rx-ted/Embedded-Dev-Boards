#include "config.h"
#include "demo.h"
#include "gfx.h"
#include "delay.h"
#include"lcd.h"
#include "touch.h"

#define PI (float)(3.1415926)

extern touch_dev_t tp;

static float cube[8][3] = {
    {-32, -32, -32},
    {-32, +32, -32},
    {+32, +32, -32},
    {+32, -32, -32},
    {-32, -32, +32},
    {-32, +32, +32},
    {+32, +32, +32},
    {+32, -32, +32}};

static uint8_t line_id[24] = {
    1, 2, 2, 3,
    3, 4, 4, 1,
    5, 6, 6, 7,
    7, 8, 8, 5,
    8, 4, 7, 3,
    6, 2, 5, 1};

/**
 * @brief       计算矩阵乘法
 * @param       a      : 矩阵a
 *              b[3][3]: 矩阵b
 * @retval      计算结果
 */
static float *demo_matconv(float *a, float b[3][3])
{
    float res[3];
    uint8_t res_index;
    uint8_t a_index;

    for (res_index = 0; res_index < 3; res_index++)
    {
        res[res_index] = b[res_index][0] * a[0] + b[res_index][1] * a[1] + b[res_index][2] * a[2];
    }

    for (a_index = 0; a_index < 3; a_index++)
    {
        a[a_index] = res[a_index];
    }

    return a;
}

/**
 * @brief       旋转向量
 * @param       point: 需要旋转的向量
 *              x    : X轴旋转量
 *              y    : Y轴旋转量
 *              z    : Z轴旋转量
 * @retval      计算结果
 */
static void demo_rotate(float *point, float x, float y, float z)
{
    float rx[3][3];
    float ry[3][3];
    float rz[3][3];

    x /= PI;
    y /= PI;
    z /= PI;

    rx[0][0] = cos(x);
    rx[0][1] = 0;
    rx[0][2] = sin(x);
    rx[1][0] = 0;
    rx[1][1] = 1;
    rx[1][2] = 0;
    rx[2][0] = -sin(x);
    rx[2][1] = 0;
    rx[2][2] = cos(x);

    ry[0][0] = 1;
    ry[0][1] = 0;
    ry[0][2] = 0;
    ry[1][0] = 0;
    ry[1][1] = cos(y);
    ry[1][2] = -sin(y);
    ry[2][0] = 0;
    ry[2][1] = sin(y);
    ry[2][2] = cos(y);

    rz[0][0] = cos(z);
    rz[0][1] = -sin(z);
    rz[0][2] = 0;
    rz[1][0] = sin(z);
    rz[1][1] = cos(z);
    rz[1][2] = 0;
    rz[2][0] = 0;
    rz[2][1] = 0;
    rz[2][2] = 1;

    demo_matconv(demo_matconv(demo_matconv(point, rz), ry), rx);
}

/**
 * @brief       演示立方体3D旋转
 * @param       无
 * @retval      无
 */
static void demo_show_cube(void)
{
    uint8_t point_index;
    uint8_t line_index;
    static uint16_t x = 57;
    static uint16_t y = 139;

#if (BSP_USING_TOUCH != 0)

    /* RGB LCD模块触摸扫描 */
    device_result_code_t res = tp.scan();
    if (res != DEVICE_SUCCESS)
    {
        return;
    }

    {
        if ((tp.point[0].x > 56) && (tp.point[0].x < (lcddev.width - 56)) && (tp.point[0].y > 138) && (tp.point[0].y < (lcddev.height - 56)))
        {
            x = tp.point[0].x;
            y = tp.point[0].y;
        }
    }
#endif

    for (point_index = 0; point_index < 8; point_index++)
    {
        demo_rotate(cube[point_index], 0.05f, 0.03f, 0.02f);
    }

    for (line_index = 0; line_index < 24; line_index += 2)
    {
        /* RGB LCD模块LCD画线段 */
        draw_line(x + cube[line_id[line_index] - 1][0],
                  y + cube[line_id[line_index] - 1][1],
                  x + cube[line_id[line_index + 1] - 1][0],
                  y + cube[line_id[line_index + 1] - 1][1],
                  BLUE);
    }

    delay_ms(5);

    // fill
    fill_clear(x - 56, y - 56, x + 56, y + 56, WHITE);
}

/**
 * @brief       例程演示入口函数
 * @param       无
 * @retval      无
 */
void demo_run(void)
{

    gfx_init();
    touch_init();
    /* RGB LCD模块LCD清屏 */
    fill_clear(0, 0, lcddev.width, lcddev.height, WHITE);
    /* RGB LCD模块LCD显示字符串 */

    show_string(10, 10, 200, 32, "STM32", GFX_FONT_32, RED);
    show_string(10, 42, 200, 24, "ATK-MD0430R-800480", GFX_FONT_24, RED);
    show_string(10, 66, 200, 16, "ATOM@ALIENTEK", GFX_FONT_16, RED);

    while (1)
    {
        /* 演示立方体3D旋转 */
        demo_show_cube();
    }
}
