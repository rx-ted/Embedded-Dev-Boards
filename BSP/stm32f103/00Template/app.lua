---@param user_config MyConfig
local user_config = {
    board_name = 'stm32f103',
    project_name = '00Template',
    asm_file = 'Drivers/CMSIS/Device/cmsis-device-f1/Source/Templates/gcc/startup_stm32f103xb.s',
    ld_file = 'BSP/stm32f103/00Template/stm32f103c8tx_flash.ld',
    defines = {"USE_HAL_DRIVER", "STM32F103xB"},
    remove_files = {"Drivers/CMSIS/Device/cmsis-device-f1/Source/Templates/*.c", "**/*template.c"},
    openocd = {
        interface_name = 'interface/cmsis-dap.cfg', -- or 'stlink.cfg'
        target_name = 'target/stm32f1x.cfg', -- specifies the target configuration file for the board
        options = '' -- For example: `-c 'cmsis_dap_backend hid' -c 'transport select swd'`
    },
    c_files = { -- Add paths to your .c source files here.
    'BSP/stm32f103/00Template/**.c', "Middlewares/lcd/ssd1306/*.c", 'Middlewares/malloc/*.c'},
    cc_files = {
        -- Add paths to your .cpp or .cc source files here.
    },
    header_dirs = { -- Add paths to your header directories here.
    'BSP/stm32f103/00Template/**', 'Middlewares/lcd/ssd1306', 'Middlewares/malloc'}
}

-- Do not alter!!!
---@param key string
---@param value string|string[]
function set_user_config(key, value)
    user_config[key] = value
end

---@return MyConfig
function get_user_config()
    return user_config
end
