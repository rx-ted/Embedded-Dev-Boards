local user_config = {
    board_name = 'stm32f427',
    project_name = '00Template',
    asm_file = 'Drivers/CMSIS/Device/cmsis-device-f4/Source/Templates/gcc/startup_stm32f427xx.s',
    ld_file = 'BSP/stm32f427/00Template/stm32f427zgtx_flash.ld',
    defines = {"USE_HAL_DRIVER", "STM32F427xx", "BSP_USING_TOUCH=1", "BSP_USING_LVGL=1", "DEBUG", },
    remove_files = {"Drivers/CMSIS/Device/cmsis-device-f4/Source/Templates/*.c", "**/*template.c"},
    openocd = {
        interface_name = 'interface/cmsis-dap.cfg', -- or 'stlink.cfg'
        target_name = 'target/stm32f4x.cfg',
        options = '' -- for example: -c 'cmsis_dap_backend hid' -c 'transport select swd'
    },
    c_files = { -- Add paths to your .c source files here.
    'BSP/stm32f427/00Template/**.c'},
    cc_files = {
        -- Add paths to your .cpp or .cc source files here.
    },
    header_dirs = { -- Add paths to your header directories here.
    'BSP/stm32f427/00Template/**'}

}

function set_user_config(k, v)
    user_config[k] = v
end

function get_user_config()
    return user_config
end
