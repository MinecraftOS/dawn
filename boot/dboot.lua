--dawn default boot program
--by dusk

local ver = fs.open("/etc/.dawninf", "r")
local v = ver.readLine()
local kerv = ver.readLine()
ver.close()

local ke = require "/kernel"

local fromROM = {
    "/bin/ls.lua",
    "/bin/edit.lua"
}

for k,v in pairs(fromROM) do
    if fs.exists(v) then
        ke.scrMSG(1,"exists: "..v)
    else
        if v == "/bin/ls.lua" then
            fs.copy("/rom/programs/list.lua",v)
        elseif v == "/bin/edit.lua" then
            fs.copy("/rom/programs/edit.lua",v)
        end
        ke.scrMSG(3,"had to copy from rom: "..v)
    end
end

local tSizex, tSizey = term.getSize()
sleep(1)
term.clear()
if tSizex == 26 and tSizey == 20 then
    term.setCursorPos(11,4)
    local image = paintutils.loadImage("/etc/dawn/logo.nfp")
    paintutils.drawImage(image, term.getCursorPos())
    xpos = dawn.findCenter2("Dawn OS pre-"..v)
    term.setCursorPos(xpos,13)
    print("Dawn OS pre-"..v)
    xpos = dawn.findCenter2(kerv)
    term.setCursorPos(xpos,1)
    print(kerv)
    xpos = dawn.findCenter2("ENTER to boot to login,")
    term.setCursorPos(xpos,18)
    print("ENTER to boot to login,")
    xpos = dawn.findCenter2(" Z to boot to dbios.")
    term.setCursorPos(xpos,19)
    write(" Z to boot to dbios.")
else
    term.setCursorPos(22,4)
    local image = paintutils.loadImage("/etc/dawn/logo.nfp")
    paintutils.drawImage(image, term.getCursorPos())
    xpos = dawn.findCenter2("Dawn OS pre-"..v)
    term.setCursorPos(xpos,13)
    print("Dawn OS pre-"..v)
    xpos = dawn.findCenter2(kerv)
    term.setCursorPos(xpos,1)
    print(kerv)
    xpos = dawn.findCenter2("ENTER to boot to login, Z to boot to dbios.")
    term.setCursorPos(xpos,18)
    print("ENTER to boot to login, Z to boot to dbios.")
end
while true do
    local event = {os.pullEvent()}
    local eventD = event[1]

    if eventD == "key" then
        local k = event[2]
        if k == keys.enter then
          term.clear()
          term.setCursorPos(1,1)
          sleep(0.9)
          shell.run("/bin/login.lua")
          break
        elseif k == keys.z then
            term.clear()
            term.setCursorPos(1,1)
            sleep(0.9)
            shell.run("/boot/dbios/init.lua")
            break
        end
    end
end
