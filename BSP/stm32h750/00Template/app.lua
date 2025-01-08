local user_config = {
    asm_file = 'Drivers/CMSIS/Device/cmsis-device-h7/Source/Templates/gcc/startup_stm32h750xx.s',
    ld_file = 'BSP/stm32h750/00Template/stm32h750xbhx_flash.ld',
    defines = {"STM32H750xx", "USE_HAL_DRIVER", "DEBUG", "USE_PWR_LDO_SUPPLY"},
    remove_files = {"Drivers/CMSIS/Device/cmsis-device-h7/Source/Templates/*.c", "**/*template.c"},
    openocd = {
        interface_name = 'interface/stlink.cfg', -- or 'stlink.cfg'
        target_name = 'target/stm32h7x.cfg',
        options = '' -- for example: -c 'cmsis_dap_backend hid' -c 'transport select swd'
    }
}

function set_user_config(k, v)
    user_config[k] = v
end

function get_user_config()
    return user_config
end
