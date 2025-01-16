function getIncludeDirsAndFiles(target, match_dirs)
    if type(match_dirs) ~= 'table' then
        print("Error: 'match_dirs' should be a table")
        return false
    end
    for _, filedirs in ipairs(match_dirs) do
        for _, filedir in ipairs(os.filedirs(filedirs)) do
            if os.isfile(filedir) then
                local extension_name = path.extension(filedir)
                -- check source file
                if (extension_name == '.c' or extension_name == '.cpp' or extension_name == '.cc') then
                    try {function()
                        if not table.contains(target:get('files'), filedir) then
                            target:add('files', filedir)
                        end
                    end, catch {function()
                        target:add('files', filedir)
                    end}}

                    -- check header file 
                elseif extension_name == '.h' then
                    try {function()
                        if not table.contains(target:get('includedirs'), path.directory(filedir)) then
                            target:add('includedirs', path.directory(filedir))
                        end
                    end, catch {function()
                        target:add('includedirs', path.directory(filedir))
                    end}}

                end
            end
        end
    end
    return true
end

---@param match_dirs string[]|any
local function traverse_header_dirs(match_dirs)
    if type(match_dirs) ~= 'table' then
        print("Error: 'match_dirs' should be a table")
        return nil
    end
    local collect_dirs = {}
    for _, dirs in ipairs(match_dirs) do
        for _, file in ipairs(os.files(dirs .. '/*.h')) do
            table.insert(collect_dirs, dirs)
            break
        end
    end
    return collect_dirs
end

---@param match_dirs string[]|any
---@return string[]|nil
local function traverse_dirs(match_dirs)
    if type(match_dirs) ~= 'table' then
        print("Error: 'match_dirs' should be a table")
        return nil
    end
    local collect_dirs = {}
    for _, dirs in ipairs(match_dirs) do
        for _, dir in ipairs(os.dirs(dirs)) do
            table.insert(collect_dirs, dir)
        end
    end
    return collect_dirs
end

---@param user_config MyConfig
function parsingUserConfig(configs, user_config)
    local target = configs.target
    local user_config = configs.app.get_user_config()

    if user_config.asm_file then
        target:add('files', user_config.asm_file)
    end
    if user_config.c_files then
        for _, file in ipairs(user_config.c_files) do
            target:add('files', file)
        end
    end
    if user_config.cc_files then
        for _, file in ipairs(user_config.cc_files) do
            target:add('files', file)
        end
    end
    if user_config.remove_files then
        for _, file in ipairs(user_config.remove_files) do
            target:remove('files', file)
        end
    end
    if user_config.defines then
        for _, definition in ipairs(user_config.defines) do
            target:add('defines', definition)
            configs.search.check_driver(configs, definition)
        end
    end
    if user_config.board_name and user_config.project_name and user_config.ld_file then
        target:add('ldflags', "-specs=nano.specs",
            string.format("-T%s -lc -lm -lnosys -Wl,-Map=%s/%s.map,--cref -Wl,--gc-sections", user_config.ld_file,
                'BSP/' .. user_config.board_name .. '/' .. user_config.project_name .. '/Output',
                user_config.project_name))
    end
    if user_config.header_dirs then
        local dirs = traverse_header_dirs(traverse_dirs(user_config.header_dirs))
        if dirs ~= nil then
            for _, dir in ipairs(dirs) do
                target:add('includedirs', dir)
            end
        end
    end

    if user_config.openocd then
        configs.openocd = user_config.openocd
    end

end
