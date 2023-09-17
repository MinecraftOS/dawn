--system management stuff
--must always be run with sudo no matter what, obvs
--stuff like system configs etc will be moved to here

local function e(s)
    return s == nil or s == ""
end

local lio = require "/lib/libio"
local args = {...}

if args[1] == "-h" then
    print("sysmgr - system management (must be run with sudo)")
    print("sysmgr --cleanup | cleanup all temp/dump files")
    print("sysmgr --default-sh | set the default shell")
    print("sysmgr --clear-config | clear /etc/config/")
    print("sysmgr --regadd <value> | add an entry to the registry")
    print("sysmgr --regrem <value> | remove an entry from the registry")
end

if fs.exists("/tmp/sudo") then
    if args[1] == "--cleanup" then
        shell.run("rm /tmp/*")
        shell.run("rm /etc/dump/*")
        shell.run("rm /var/dump/*")
    elseif args[1] == "--default-sh" then
    if fs.exists("/etc/dawn/sh-default") then
        fs.delete("/etc/dawn/sh-default")
    end
        local handle = fs.open("/etc/dawn/sh-default","w")
        handle.write(args[2])
        handle.close()
    elseif args[1] == "--clear-config" then
        term.setTextColor(colors.red)
        write("WARNING: Clears /etc/config. Continue? ")
        sleep(1)
        term.setTextColor(colors.white)
        local a = lio.ynae.npref()
        if a == true then
            shell.run("rm /etc/config/*")
        elseif a == false then
            error("Bailing!",0)
        end
    elseif args[1] == "--regadd" then
        if fs.exists("/sys/reg/"..args[2]) then
            error("Registry value already exists: "..args[2],0)
        else
            local handle = fs.open("/sys/reg/"..args[2],"w")
            handle.write("")
            handle.close()
            print("Registry value added: "..args[2])
        end
    elseif args[1] == "--regrem" then
        if fs.exists("/sys/reg/"..args[2]) ~= true then
            error("Registry value does not exist: "..args[2],0)
        else
            fs.delete("/sys/reg/"..args[2])
            print("Removed registry value: "..args[2])
        end
    end
else
    error("Must be run with sudo.",0)
end
