--make a file at the defined destination
local args = {...}
local k = require "/kernel"

if fs.exists(args[1]) then
    write(args[1].." exists already. Make "..args[1].."-1? [Y/n]")
    local input = read()
    if input == "y" then
        fs.copy("/etc/file",args[1].."-1")
    elseif input == "n" then
        error("Cancelling!",0)
    elseif k.empty(input) then
        fs.copy("/etc/file",args[1].."-1")
    else
        error("Cancelling due to invalid input!",0)
    end
else
    if args[1] == "/tmp/sudo" then
        error("Cannot bypass sudo perms.",0)
    else
        fs.copy("/etc/file",args[1])
    end
end
