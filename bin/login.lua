--[[
    Login for DASH
    By Dusk
]]

local kernel = require "/kernel"

if fs.exists("/var/logs/login") then
    fs.delete("/var/logs/login")
end

local log = fs.open("/var/logs/login","w")
log.writeLine("== LOGIN PROMPT LOG ==")

kernel.scrMSG(1,"Reached: login")

local function isempty(s) --i robbed this from https://stackoverflow.com/questions/19664666/check-if-a-string-isnt-nil-or-empty-in-lua
    return s == nil or s == ''
end

if fs.exists("/etc/usr/.login") then
    log.writeLine("Deleted: /etc/usr/.login")
    fs.delete("/etc/usr/.login")
end

log.writeLine("Perform login and related auth.")

log.close()
local handle = fs.open("/etc/passwd","r")
write("User:")
local userlog = read()
if isempty(userlog) then
    os.reboot()
end

if userlog == "dbios" then
    shell.run("/boot/dbios/init.lua")
    error()
end

write("Password:")
local userpass = read("#")
if isempty(userpass) then
    os.reboot()
end
local cshell
local user
local pass
local id
local home

repeat
    local a = handle.readLine()
    if a == nil then
        os.reboot()
    end
    user, pass, id, home, cshell = string.match(a, "([^:]+):([^:]+):([^:]+):([^:]+):([^:]+)") --check users info. name, shell, id, password, etc
    if user == nil then
        kernel.scrMSG(4,"No user found.")
        sleep(1)
        os.reboot()
    end
    if pass == nil then
        kernel.scrMSG(4,"No user found.")
        sleep(1)
        os.reboot()
    end
  until
    user == userlog and pass == userpass
    handle.close()
    local log = fs.open("/var/logs/login","a")
    log.writeLine("Authentication complete.")
    log.close()
    local handle2 = fs.open("/etc/usr/.login","w")
    handle2.writeLine(user)
    handle2.close()
    if fs.exists("/etc/sh-default") then
        defaultsh = fs.open("/etc/sh-default","r")
    else
        defaultsh = fs.open("/etc/dawn/sh-default","r")
    end
    local sh = defaultsh.readLine()
    defaultsh.close()
    local log = fs.open("/var/logs/login","a")

    if fs.exists(home) then
        log.writeLine("Home dir for "..user.." exists. ("..home..")")
        shell.run("cd "..home)
    else
        log.writeLine("Home dir for "..user.." does not exist. Default cd to /bin/")
        shell.run("cd /bin/")
    end

    if fs.exists(cshell) then
        log.writeLine("Chosen shell ("..cshell..") exists. Run.")
        log.close()
        shell.run(cshell)
    else
        log.write("Chosen shell ("..cshell..") does not exist, ")
        if fs.exists("/usr/bin/"..sh..".lua")  then
            log.write("however defined default shell ("..sh..") does exist, run that instead.\n")
            print(cshell,"does not exist, using /usr/bin/"..sh)
            log.close()
            shell.run("/usr/bin/"..sh)
        else
        log.write("neither does /usr/bin/"..sh.."\n")
            print(cshell,"and /usr/bin/"..sh,"don't exist, use dash or download it")
            if fs.exists("/usr/bin/dash.lua") then
                log.writeLine("dash exists, run that.")
                log.close()
                shell.run("/usr/bin/dash.lua")
            else
                log.writeLine("dash doesn't exist; and I ask why.")
                log.writeLine("Whatever, just download and run.")
                shell.run("wget https://raw.githubusercontent.com/XDuskAshes/dawn/idev/usr/bin/dash.lua /usr/bin/dash.lua")
                log.writeLine("Downloaded, run.")
                log.close()
                shell.run("/usr/bin/dash.lua")
            end
        end
    end
