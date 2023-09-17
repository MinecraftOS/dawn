--custom made cd

local args = {...}

if args[1] == "-h" then
    print("Usage: cd <dir>")
    print("Full paths are supported.")
elseif #args < 1 then
    error("No dir arg given")
else
    local dir = shell.resolve(args[1])
    if fs.isDir(dir) then
        shell.setDir(dir)
    else
        error(dir.." is not a valid dir",0)
    end
end
