--dawn installer

local spinner = {"|","/","-","\\"}
local stage = 0
local stages = 6
local rfs = {}
local files = {}
local user
local pass
local rpass

local function loadingBar(step,steps,YPos)
    local oldCursorPosX,oldCursorPosY = term.getCursorPos()
    local oldBGC = term.getBackgroundColor()
    maxX,maxY = term.getSize()
    if YPos == nil then --this part may not be needed but is here if something changes in the future
        YPos = maxY-1
    end
    term.setCursorPos(1,YPos)
    term.setBackgroundColor(colors.gray)
    print(string.rep(" ",maxX))
    term.setBackgroundColor(colors.red)
    term.setCursorPos(1,YPos)
    print(string.rep(" ",((step/steps)*maxX)))
    term.setBackgroundColor(oldBGC)
    term.setCursorPos(oldCursorPosX,oldCursorPosY)
end

--[[
    stage = (stage % 4) + 1
    term.clearLine(term.getCursorPos())
    write(" make basefs... "..spinner[stage])
]]

local fshandle = assert(http.get("https://raw.githubusercontent.com/XDuskAshes/dawn/idev/install/fs"))
repeat
    local a = fshandle.readLine()
    table.insert(rfs,a)
until a == nil
fshandle.close()

local fihandle = assert(http.get("https://raw.githubusercontent.com/XDuskAshes/dawn/idev/install/files"))
repeat
    local a = fihandle.readLine()
    table.insert(files,a)
until a == nil
fihandle.close()

local function e(s)
    return s == nil or s == ""
end

term.clear()
term.setCursorPos(1,1)
loadingBar(1,stages,nil)
print("Welcome to Dawn OS, a simple, *NIX-Like operating system for YOUR ComputerCraft:Tweaked system!")
print("")
print("For now, the installer will only install from the 'idev' branch of Dawn, however in the future you will be able to download a stable release version of Dawn!")
print("")
print("Press any key to continue...")
        while true do
            local event = {os.pullEvent()}
            local eventD = event[1]
        
            if eventD == "key" then
                break
            end
        end
term.clear()
term.setCursorPos(1,1)
loadingBar(2,stages,nil)
print("First, we'll need to setup a user account.")
print("Enter a username and password as prompted:")
while true do
    write("Username: ")
    user = read()
    if e(user) then
        print("Username can't be blank.")
    else
        break
    end
end

while true do
    write("Password: ")
    pass = read("*")
    if e(pass) then
        print("Password cannot be blank.")
    elseif string.len(pass) < 8 then
        print("Password length cannot be less than 8 characters.")
    else
        break
    end
end
print("Press any key to continue...")
        while true do
            local event = {os.pullEvent()}
            local eventD = event[1]
        
            if eventD == "key" then
                break
            end
        end

term.clear()
term.setCursorPos(1,1)
loadingBar(3,stages,nil)
print("Now set a password for the root account.")
while true do
    write("Root password: ")
    rpass = read("*")
    if e(rpass) then
        print("Root password cannot be blank.")
    elseif string.len(rpass) < 8 then
        print("Root password length cannot be less than 8 characters.")
    else
        break
    end
end

print("Press any key to continue...")
        while true do
            local event = {os.pullEvent()}
            local eventD = event[1]
        
            if eventD == "key" then
                break
            end
        end

term.clear()
term.setCursorPos(1,1)
loadingBar(4,stages,nil)
print("Now just a few quick questions.")
print("Would you like a home directory? (/home/"..user..")")
print("[Y/n]")
local home
    while true do
        local event = {os.pullEvent()}
        local eventD = event[1]
    
        if eventD == "key" then
            local k = event[2]
            if k == keys.y then
              home = "/home/"..user
              print("A home dir will be made.")
              break
            elseif k == keys.n then
                home = "nil"
                print("A home dir will not be made.")
                break
            end
        end
    end
loadingBar(5,stages,nil)
print("Which shell would you like to use?")
print("(1) - dash")
print("(2) - minterm")
local sh
    while true do
        local event = {os.pullEvent()}
        local eventD = event[1]
    
        if eventD == "key" then
            local k = event[2]
            if k == keys.one then
              sh = "/usr/bin/dash.lua"
              print("dash selected")
              break
            elseif k == keys.two then
                sh = "/usr/bin/minterm.lua"
                print("minterm selected")
                break
            end
        end
    end

loadingBar(6,stages,nil)
print("Press any key to continue...")
        while true do
            local event = {os.pullEvent()}
            local eventD = event[1]
        
            if eventD == "key" then
                break
            end
        end

term.clear()
term.setCursorPos(1,1)
print("Dawn OS will now be installed.")
local x,y = term.getCursorPos()
for k,v in pairs(rfs) do
    fs.makeDir(v)
    term.setCursorPos(1,2)
    term.clearLine(term.getCursorPos())
    write("Make basefs... ("..v..")")
    sleep(0.01)
end
print(" | Done!")

for k,v in pairs(files) do
    local handle = assert(http.get("https://raw.githubusercontent.com/XDuskAshes/dawn/idev"..v))
        local toWrite = {}
        repeat
            local a = handle.readLine()
            table.insert(toWrite,a)
        until a == nil
    handle.close()

    handle = fs.open(v,"w")
    for _,v in pairs(toWrite) do
        handle.writeLine(v)
    end
    handle.close()

    term.setCursorPos(1,3)
    term.clearLine(term.getCursorPos())
    write("Make core... ("..v..")")
    sleep(0.01)
end
print(" | Done!")
print("Dawn OS files are installed.")

print("Press any key to finish installation...")
        while true do
            local event = {os.pullEvent()}
            local eventD = event[1]
        
            if eventD == "key" then
                break
            end
        end

term.clear()
term.setCursorPos(1,1)
fs.copy("/rom/programs/list.lua","/bin/ls.lua")
fs.copy("/rom/programs/edit.lua","/bin/edit.lua")
print("Copied ls and edit from rom.")

local handle = fs.open("/etc/passwd","w")
handle.writeLine("root:"..rpass..":0:nil:/usr/bin/dash.lua")
handle.writeLine(user..":"..pass..":1:"..home..":"..sh)
handle.close()
print("Done writing user!")
print("You will now be sent into your new Dawn system!")
sleep(3)
shell.run("/startup.lua")
