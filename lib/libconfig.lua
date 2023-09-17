--[[
    Configs lib
    By Dusk
    For configuration stuff
]]

local c = {}

function c.makeConfig(path,defaultContent) --create a config file and put default text inside. Expects "defaultContent" to be a table.
    local handle = fs.open(path,"w")
    handle.writeLine("; Generated using libconfig")
    for k,v in pairs(defaultContent) do
        handle.writeLine(v)
    end
    handle.close()
end

function c.readConfig(path) --read a config file. Returns contents as a table.
    local a = {}
    local handle = fs.open(path,"r")
    repeat
        local b = handle.readLine()
        table.insert(a,b)
    until b == nil
    handle.close()
    return a
end

return c
