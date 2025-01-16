-- local board_name = 'stm32h750'
-- local board_name = 'stm32f427'
local board_name = 'stm32f103'
-- local project_name = '01Blink'
local project_name = '00Template'

local app_dir = 'BSP/' .. board_name .. '/' .. project_name
local target_dir = app_dir .. '/Output'
local configs

set_project(app_dir)
set_version('1.0')
add_rules("mode.debug")

target(app_dir)

set_kind("binary")
set_arch('cross')
set_plat('cross')
set_optimize("fastest")
set_symbols("debug")
set_warnings('all')

on_config(function(target)

    local path = string.format("%s/app.lua", app_dir)
    if not os.exists(path) then
        cprint(string.format(
            "${bright red onwhite}Error: The path %s does not exist. Please verify the board_name and project_name.",
            path))
        os.exit(1)
    end

    local import_configs = import('Tools.utils.config')
    -- add object to import_configs
    import_configs.set_config('target', target)
    import_configs.set_config('app', import(string.format('BSP.%s.%s.app', board_name, project_name)))
    import_configs.set_config('utils', import('Tools.utils.utils'))
    import_configs.set_config('search', import('Tools.utils.search'))
    -- get all configs
    configs = import_configs.get_configs()
    -- set user_config to  import_configs
    import_configs.set_config('user_config', configs.app.get_user_config())

    configs.utils.parsingUserConfig(configs)

    -- ignore flag
    target:set('policy', "check.auto_ignore_flags", false)
    target:set('targetdir', target_dir)
    target:set('filename', project_name .. '.elf')

end)

-- 构建完成后的回调函数
after_build(function(target)
    local content = string.format('.configurations[0].includePath=[\"%s\"]',
        table.concat(target:get('includedirs'), '","'))
    local outdata, errdata = os.iorunv("jq", {content, ".vscode/c_cpp_properties.json"})
    if outdata then
        io.writefile(".vscode/c_cpp_properties.json", outdata)
    end
    local content = string.format('.configurations[0].defines=[\"%s\"]', table.concat(target:get('defines'), '","'))
    local outdata, errdata = os.iorunv("jq", {content, ".vscode/c_cpp_properties.json"})
    if outdata then
        io.writefile(".vscode/c_cpp_properties.json", outdata)
    end
    local targetfile_prefix = string.sub(target:targetfile(), 0,
        #target:targetfile() - #path.extension(target:targetfile()))
    cprint("${bright black onwhite}********************储存空间占用情况*****************************")

    os.exec(string.format("arm-none-eabi-objcopy -O ihex %s %s.hex", target:targetfile(), targetfile_prefix))
    os.exec(string.format("arm-none-eabi-objcopy -O binary %s %s.bin", target:targetfile(), targetfile_prefix))
    print("生成已完成!")
    -- os.exec(string.format("arm-none-eabi-size -Ax %s", target:targetfile()))
    os.exec(string.format("arm-none-eabi-size -Bd %s", target:targetfile()))
    cprint(
        "${bright black onwhite}heap-堆、stack-栈、.data-已初始化的变量全局/静态变量,bss-未初始化的data、.text-代码和常量")
end)

on_run(function(target)
    local openocd = configs.openocd
    if openocd.interface_name == nil or openocd.target_name == nil or openocd.options == nil then
        cprint(
            string.format("${bright red onwhite}Error: Please verify the interface_name and target_name for OpenOCD!"))
        return
    end
    local cmd = string.format("openocd -f %s -f %s -c %s 'program %s verify reset exit'", openocd.interface_name,
        openocd.target_name, openocd.options, target:targetfile())
    cprint(string.format("${bright black onwhite}%s", cmd))
    os.exec(cmd)
end)

target_end()

