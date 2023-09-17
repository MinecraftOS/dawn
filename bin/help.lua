--[[
    Help program
    Pull from /etc/dash/help/
    By Dusk
]]

local kernel = require "/kernel"

local args = {...}
if #args < 1 then
    shell.run("ls /bin/")
elseif args[1] == "-h" then
print([[
Help utility

help | lists /bin/
help <program> | runs /bin/<program> -h]])
else
    if fs.exists("/bin/"..args[1]..".lua") then
        shell.run("/bin/"..args[1].." -h")
    else
        error("Program "..args[1].." does not exist.",0)
    end
end
