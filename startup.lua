shell.run("set shell.allow_disk_startup false")

local function e(s)
    return s == nil or s == ""
end

local id = os.getComputerID()
local label = os.getComputerLabel()
local ComLab
local comname

if label == nil then
    ComLab = id
else
    ComLab = label
end

if fs.exists("/etc/hostname") then
    local handle = fs.open("/etc/hostname","r")
    comname = handle.readLine()
    handle.close()

    if e(comname) then
        local handle = fs.open("/etc/hostname","w")
        handle.writeLine("DAWNOS-"..ComLab)
    end
else
    local handle = fs.open("/etc/hostname","w")
    handle.writeLine("DAWNOS-"..ComLab)
    handle.close()
end

term.clear()

local handle = fs.open("/etc/hostname","r")
comname = handle.readLine()
handle.close()

local spinner = {"|","/","-","\\"}
local stage = 0

local handle = fs.open("/var/logs/startup","w")
handle.writeLine("DAWN CP-BSL (Computer Post-Boot State Log)")

local tSizex, tSizey = term.getSize()

shell.run("label set "..comname)

handle.writeLine("set computer label to "..comname)

term.clear()
term.setCursorPos(1,1)
print("DAWN CP-BSL (Computer Post-Boot State Log)") --Computer Post-Boot State Log
print("YABADEV KERNEL PATCH 6 RELEASE 3")
handle.writeLine("Termsize ["..tSizex..","..tSizey.."]")
print("Termsize ["..tSizex..","..tSizey.."]")
handle.writeLine("ID/Label: "..ComLab)
print("ID/Label:",ComLab)
print("Color scale:")
print("==================")
write("|")
local col = 1
local shuffle = 2
repeat
    paintutils.drawPixel(shuffle, 6, col)
    col = col * 2
    shuffle = shuffle + 1
until col == 65536
print("|")
print("==================")
local c = os.clock()
handle.writeLine("Basic info retrieved in: "..c.."s")
handle.close()
sleep(1)
term.clear()
term.setCursorPos(1,1)

local handle = assert(http.get("https://raw.githubusercontent.com/XDuskAshes/dawn/idev/install/fs"))
    local bfs = {}
    repeat
        local a = handle.readLine()
        table.insert(bfs,a)
    until a == nil
handle.close()

local handle2 = assert(http.get("https://raw.githubusercontent.com/XDuskAshes/dawn/idev/install/files"))
    local bfiles = {}
    repeat
        local a = handle2.readLine()
        table.insert(bfiles,a)
    until a == nil
handle2.close()

local x,y = term.getCursorPos()
for k,v in pairs(bfs) do
    if fs.exists(v) then
        term.setCursorPos(x,y)
        stage = (stage % 4) + 1
        write("running basefs check... ".. spinner[stage].." ")
    else
        fs.makeDir(v)
        term.setCursorPos(x,y)
        stage = (stage % 4) + 1
        write("running basefs check... ".. spinner[stage].." ")
    end
    sleep(0.01)
end
stage = 0
print("done")

x,y = term.getCursorPos()
for k,v in pairs(bfiles) do
    if fs.exists(v) then
        term.setCursorPos(x,y)
        stage = (stage % 4) + 1
        write("running basefiles check... ".. spinner[stage].." ")
    else
        handle = assert(http.get("https://raw.githubusercontent.com/XDuskAshes/dawn/idev/"..v))
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
        term.setCursorPos(x,y)
        stage = (stage % 4) + 1
        write("running basefiles check... ".. spinner[stage].." ")
    end
    sleep(0.01)
end

local handle = fs.open("/var/logs/startup","a")
handle.writeLine("completed basefs and basefiles checks")

print("done")
write("resolve env... ")
if not periphemu then
    print("CCEmuX/Base CC")
    handle.writeLine("env is CCEmuX/Base CC")
else
    print("CCPC")
    handle.writeLine("env is CCPC")
end
stage = 0
handle.writeLine("performing bfs write")
handle.close()
if fs.exists("/sys/bfs") then
    fs.delete("/sys/bfs")
end
handle = fs.open("/sys/bfs","w")
x,y = term.getCursorPos()
for k,v in pairs(bfs) do
    handle.writeLine(v)
    term.setCursorPos(x,y)
    stage = (stage % 4) + 1
    write("performing bfs write... ".. spinner[stage].." ")
    sleep(0.01)
end

print("done")

write("Reading registry... ")

local reg = fs.list("/sys/reg/")
if e(reg[1]) then
    print("registry empty.")
else
    print("registry entries found.")
    x,y = term.getCursorPos()
    for k,v in pairs(reg) do
        if fs.exists("/sbin/regapp/"..v..".lua") then
            shell.run("/sbin/regapp/"..v..".lua")
            term.setCursorPos(x,y)
        stage = (stage % 4) + 1
        write("running regapps... ".. spinner[stage].." ")
        sleep(0.01)
        end
    end
    print("done")
end

handle.close()
local handle = fs.open("/var/logs/startup","a")
handle.writeLine("launching boot program")
handle.close()
sleep(1)
shell.run("/boot/dboot.lua")
