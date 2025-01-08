local default_config_schema = {
    board_name = {
        type = "string"
    },
    project_name = {
        type = "string"
    },
    defines = {
        type = 'table',
        default = {}
    },
    asm_file = {
        type = "string"
    },
    ld_file = {
        type = "string"
    },
    remove_files = {
        type = 'table',
        default = {}
    },
    opennocd = {
        type = 'table',
        default = {}
    }
}

function validate_config(user_config)
    local errors = {}

    for key, schema in pairs(default_config_schema) do
        local user_value = user_config[key]
        if user_value == nil then
            if schema.default == nil then
                table.insert(errors, string.format("Missing required key '%s'", key))
            else
                user_config[key] = schema.default
            end
        elseif type(user_value) ~= schema.type then
            table.insert(errors, string.format("Invalid type for key '%s', expected %s", key, schema.type))
        elseif schema.type ~= type(user_value) then
            table.insert(errors, string.format("Invalid type for key '%s', expected an array", key))
        end
    end
    if #errors > 0 then
        return false, table.concat(errors, "; ")
    else
        return true
    end
end

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
