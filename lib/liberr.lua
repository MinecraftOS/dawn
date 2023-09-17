--[[
    Errors Lib
    By Dusk
    For generic error name storage and display
]]

local e = {}

e.errnames = {
    "file cannot be found",
    "auth fail",
    "invalid in",
    "error unexpected"
}


function e.err(num)
    local to = tonumber(num)
    if not to then
        error("errlib cannot process non-numbers",0)
    end
    for k,v in pairs(e.errnames) do
        if num == k then
            error("("..fs.getName(shell.getRunningProgram())..")[ERR] "..v,0)
        end
    end
end

return e
