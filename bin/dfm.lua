--Dusk File Manager

local args = {...}
local dir
local function e(s)
    return s == nil or s == ""
end

if args[1] == "-h" then
	print([[dfm - poorly made file explorer
There is an optional argument, being where to open to.

dfm <dir>]])
error()
end

if e(args[1]) ~= true then
    if fs.isDir(args[1]) then
        shell.run("/bin/cd",args[1])
    end
end

while true do
    term.clear()
    term.setCursorPos(1,1)
        if shell.dir() == "" then
            dir = "/"
        else
            dir = "/"..shell.dir().."/"
        end
    print("["..dir.."]")
    shell.run("/bin/ls",dir)
    print("")
    term.setTextColor(colors.white)
    print("':exit' to exit")
    write("Go to/open: ")
    local a = read(nil, nil, function(str)
        return fs.complete(str, dir, {
            include_files = true,
            include_dirs = true,
            include_hidden = false,
        })
    end)
    if e(a) then
        sleep(0.3)
    elseif a == ":exit" then
        term.clear()
        term.setCursorPos(1,1)
        error()
    end
    if fs.exists(dir..a) then
        if fs.isDir(dir..a) then
            shell.run("/bin/cd",a)
        else
            shell.run("/bin/edit",a)
        end
    end
end
