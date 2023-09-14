--sudo lets go wahoo

local args = {...}
local k = require "/kernel"

if args[1] == "-h" then
    print("sudo is used as a wrapper program for other programs to run them with administrative permissions.")
    error()
end

if fs.exists("/bin/"..args[1]..".lua") ~= true then
    error(args[1].." don't exist",0)
end

if k.empty(args[1]) then
    error("sudo needs target program")
end

if fs.exists("/tmp/sudo") then
    shell.run("rm /tmp/sudo")
end

--commiting another quite literal robbery from touch
if fs.exists("/etc/usr/.login") then
    local handle = fs.open("/etc/usr/.login","r")
    local user = handle.readLine()
    handle.close()

    local handle2 = fs.open("/etc/sudoers","r")
    repeat
        local a = handle2.readLine()
        if a == nil then
            error("User does not have sudo permissions.",0)
        end
    until a == user
    handle2.close()

    local handle3 = fs.open("/etc/passwd","r")
    repeat
        local a = handle3.readLine()
        if a == nil then
            os.reboot()
        end
        --Ideally, we want no unused data, which is useless ram usage.
        --However, I don't want to break the matching.
        local usr, id, home, cshell = "", "foo", "bar", "gab"
        usr, pass, id, home, cshell = string.match(a, "([^:]+):([^:]+):([^:]+):([^:]+):([^:]+)")
        if user == nil then
            error("No user found.",0)
        end
    until user == usr
    write("Password: ")
    local input = read("#")
    if input == pass then
        local toRun = args[1]
        table.remove(args,1)
        local arg = 1
        for i,v in pairs(args) do
            toRun = toRun.." "..args[arg]
            arg = arg + 1
        end
        fs.copy("/etc/file","/tmp/sudo")
        shell.run("/bin/"..toRun)
    else
        error("Password doesn't match.",0)
    end
else
    error("/etc/usr/.login doesn't exist: cannot discern user.")
end
