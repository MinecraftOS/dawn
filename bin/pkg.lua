--[[
    PKG - Package Manager
    Downloads list from /stat/pkg/sources-list.txt
    Downloads ignore from https://raw.githubusercontent.com/XDuskAshes/dawn-pkg/main/ignore
]]

local spinner = {"|","/","-","\\"}
local stage = 0
local k = require "/kernel"
local args = {...}
local lio = require "/lib/libio"

if #args < 1 then
    error("Need arguments. 'pkg -h' for command syntax.")
elseif args[1] == "-h" then
    print([[pkg | package manager
-i <pkg> | install a package
-r <pkg> | remove a package
-l | list packages]])
else

    local handle = assert(http.get("https://raw.githubusercontent.com/XDuskAshes/dawn-pkg/main/ignore"))
    local ignore = textutils.unserialize(handle.readAll())
    handle.close()

    local handle = fs.open("/etc/pkg/sources-list.txt","r")
    local pkg_srcs = {}
    repeat
        local a = handle.readLine()
        table.insert(pkg_srcs,a)
    until a == nil
    handle.close()

        if args[1] == "-i" then
            if k.empty(args[2]) then
                error("Did not supply a package. (pkg -i <pkg>)",0)
            else
                for i,v in pairs(pkg_srcs) do
                    local handle = assert(http.get(v))
                    local pkg = textutils.unserialize(handle.readAll())

                    for b,v in pairs(pkg) do
                        if args[2] == b then
                            local handle = assert(http.get(v))
                            local pkg_info = textutils.unserialize(handle.readAll())
                            handle.close()
                            print("Name:",pkg_info[1])
                            print("Version:",pkg_info[2])
                            print("Description:",pkg_info[3])
                            write("Install? ")
                            local yn = lio.ynae.ypref()
                            if yn == true then
                                print("Installing, please wait.")
                                local handle = assert(http.get(pkg_info[4]))
                                local toWrite = {}
                                repeat
                                    local a = handle.readLine()
                                    table.insert(toWrite,a)
                                until a == nil
                                handle.close()
                                
                                local handle = fs.open("/bin/"..args[2]..".lua","w")
                                for _,v in pairs(toWrite) do
                                    handle.writeLine(v)
                                    sleep(0.01)
                                end
                                handle.close()
                                print("Done install.")
                                error()
                            else
                                error("Bailing install operation!",0)
                            end
                        end
                    end
                end
            end
        elseif args[1] == "-r" then
            if k.empty(args[2]) then
                error("Did not supply a package. (pkg -r <pkg>)",0)
            else
                for i,v in pairs(ignore) do
                    if args[2] == v then
                        error("Cannot remove "..args[2].." (defined in ignore)",0)
                    end
                end

                if fs.exists("/bin/"..args[2]..".lua") then
                    fs.delete("/bin/"..args[2]..".lua")
                    print("Done.")
                else
                    error(args[2].." does not exist or is not installed.",0)
                end
            end
        elseif args[1] == "-l" then
            for k,v in pairs(pkg_srcs) do
                local pkg_get = assert(http.get(v))
                local pkg = textutils.unserialize(pkg_get.readAll())
                pkg_get.close()
        
                for i,b in pairs(pkg) do
                    if fs.exists("/bin/"..i..".lua") then
                        write(i.." (")
                        term.setTextColor(colors.green)
                        write("INSTALLED")
                        term.setTextColor(colors.white)
                        write(")\n")
                    else
                        write(i.." (")
                        term.setTextColor(colors.red)
                        write("NOT INSTALLED")
                        term.setTextColor(colors.white)
                        write(")\n")
                    end
                end
            end
        end
end