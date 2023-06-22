--[[
    PKG - Package Manager
    Downloads list from https://raw.githubusercontent.com/XDuskAshes/dawn/pkgs/pkg-list.txt
]]

local kernel = require("/kernel")

local handle = assert(http.get("https://raw.githubusercontent.com/XDuskAshes/dawn/pkgs/pkg-list.txt"))
local pkg = textutils.unserialize(handle.readAll())
handle.close()

local dashcore = {
    "cls",
    "disk",
    "file",
    "pkg",
    "help",
    "label",
    "usr"
}

local args = {...}
if #args < 1 then
    print("Usage: pkg (-i, -r)")
    return
end

if args[1] == "-i" then
    for k,v in pairs(pkg) do
        if args[2] == k then
            shell.run("wget",v,"/usr/bin/dash/"..k..".lua")
        end
    end
end

if args[1] == "-r" then
    for k,v in pairs(dashcore) do
        if args[2] == v then
            kernel.scrMSG(4,"Cannot delete "..args[2]..": core dash file")
        end
    end
        if fs.exists("/usr/bin/dash/"..args[2]..".lua") then
            fs.delete("/usr/bin/dash/"..args[2]..".lua")
            kernel.scrMSG(1,"Deleted:"..args[2]..".lua")
        else
            kernel.scrMSG(3,"File "..args[2]..".lua doesn't exist.")
            return
        end
    end

if args[1] == "-l" then
    for k,v in pairs(pkg) do
        if fs.exists("/usr/bin/dash/"..k..".lua") then
            write(k.." (")
            term.setTextColor(colors.green)
            write("INSTALLED")
            term.setTextColor(colors.white)
            write(")\n")
        else
            print(k)
        end
    end
end