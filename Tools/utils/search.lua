local target
local dirs = {}
local MCU
local FLAGS

local board_configs = {
    stm32 = {
        f1 = {"STM32F100xB", "STM32F100xE", "STM32F101x6", "STM32F101xB", "STM32F101xE", "STM32F101xG", "STM32F102x6",
              "STM32F102xB", "STM32F103x6", "STM32F103xB", "STM32F103xE", "STM32F103xG", "STM32F105xC", "STM32F107xC"},
        f4 = {"STM32F405xx", "STM32F415xx", "STM32F407xx", "STM32F417xx", "STM32F427xx", "STM32F437xx", "STM32F429xx",
              "STM32F439xx", "STM32F401xC", "STM32F401xE", "STM32F410Tx", "STM32F410Cx", "STM32F410Rx", "STM32F411xE",
              "STM32F446xx", "STM32F469xx", "STM32F479xx", "STM32F412Cx", "STM32F412Rx", "STM32F412Vx", "STM32F412Zx",
              "STM32F413xx", "STM32F423xx"},
        h7 = {"STM32H743xx", "STM32H753xx", "STM32H750xx", "STM32H742xx", "STM32H745xx", "STM32H745xG", "STM32H755xx",
              "STM32H747xx", "STM32H747xG", "STM32H757xx", "STM32H7A3xx", "STM32H7A3xxQ", "STM32H7B3xx", "STM32H7B3xxQ",
              "STM32H7B0xx", "STM32H7B0xxQ", "STM32H735xx", "STM32H733xx", "STM32H730xx", "STM32H730xxQ", "STM32H725xx",
              "STM32H723xx"}
    }
}

local function find_board_info(board)
    local board = string.lower(board)
    for index1, board1 in pairs(board_configs) do
        for index2, board2 in pairs(board_configs[index1]) do
            for _, board3 in ipairs(board_configs[index1][index2]) do
                if board == string.lower(board3) then
                    return {
                        company_name = index1,
                        index = index2,
                        board_name = board
                    }
                end
            end
        end
    end
    return nil
end

local function set_toolset()
    target:set("toolset", 'cc', 'arm-none-eabi-gcc')
    target:set("toolset", 'cxx', 'arm-none-eabi-g++')
    target:set("toolset", 'as', 'arm-none-eabi-gcc')
    target:set("toolset", 'ld', 'arm-none-eabi-gcc')
end

local function set_stm32h7_config()
    print("Set stm32h7 config") -- Drivers/stm32h7xx-hal-driver
    dirs = {'Drivers/stm32h7xx-hal-driver/**', -- use hal driver
    'Drivers/CMSIS/Device/cmsis-device-h7/**', -- add cmsis device
    'Drivers/CMSIS/Include/**' -- default cmsis include directory
    }
    MCU = "-mcpu=cortex-m7 -mthumb -mfpu=fpv5-d16 -mfloat-abi=hard"
    FLAGS = "-gdwarf-2 -fdata-sections -ffunction-sections"

end
local function set_stm32f4_config()
    print("Set stm32f4 config")
    dirs = {'Drivers/stm32f4xx-hal-driver/**', -- use hal driver
    'Drivers/CMSIS/Device/cmsis-device-f4/**', -- add cmsis device
    'Drivers/CMSIS/Include/**' -- default cmsis include directory
    }
    MCU = "-mcpu=cortex-m4 -mthumb -mfpu=fpv4-sp-d16 -mfloat-abi=hard"
    FLAGS = "-gdwarf-2 -fdata-sections -ffunction-sections"
end

local function set_stm32f1_config()
    print("Set stm32f1 config")
    dirs = {'Drivers/stm32f1xx-hal-driver/**', -- use hal driver
    'Drivers/CMSIS/Device/cmsis-device-f1/**', -- add cmsis device
    'Drivers/CMSIS/Include/**' -- default cmsis include directory
    }
    MCU = "-mcpu=cortex-m3 -mthumb" 
    FLAGS = "-gdwarf-2 -fdata-sections -ffunction-sections"
end

function check_driver(configs, name)
    target = configs.target
    local board_info = find_board_info(name)
    if board_info == nil then
        return
    end

    if board_info.company_name == 'stm32' then
        set_toolset()
        if board_info.index == 'f1' then
            set_stm32f1_config()
        elseif board_info.index == 'f4' then
            set_stm32f4_config()
        elseif board_info.index == 'h7' then
            set_stm32h7_config()
        else
            print(string.format('Please configurate %s', board_info.board_name))
            return
        end
    end

    target:set('languages', "c99", "c++11")
    target:add('cflags', MCU, FLAGS)
    target:add('cxxflags', MCU, FLAGS)
    target:add('asflags', MCU, FLAGS, "-x assembler-with-cpp")
    target:add('ldflags', MCU, FLAGS)

    if not configs.utils.getIncludeDirsAndFiles(target, dirs) then
        os.exit(1)
    end

end

