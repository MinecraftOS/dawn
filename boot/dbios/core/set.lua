--[[
    dbios set
    by Dusk
]]

local k = require "/kernel"

local args = {...}

if k.empty(args[1]) then
    error("set bail <path> or set boot <path>",0)
end

if args[1] == "bail" then
    if k.empty(args[2]) then
        error("path cannot be nil or blank",0)
    else
        if fs.exists(args[2]) then
            if fs.isDir(args[2]) then
                error(args[2].." cannot be set (is dir)",0)
            else
                fs.delete("/boot/.bailto")
                fs.copy("/etc/file","/boot/.bailto")
                local handle = fs.open("/boot/.bailto","w")
                handle.write(args[2])
                handle.close()
                print("Done!")
            end
        else
            error(args[2].." cannot be set (nil path)",0)
        end
    end
elseif args[1] == "boot" then
    if k.empty(args[2]) then
        error("path cannot be nil or blank",0)
    else
        if fs.exists(args[2]) then
            if fs.isDir(args[2]) then
                error(args[2].." cannot be set (is dir)",0)
            else
                fs.delete("/boot/.bootfile")
                fs.copy("/etc/file","/boot/.bootfile")
                local handle = fs.open("/boot/.bootfile","w")
                handle.write(args[2])
                handle.close()
                print("Done!")
            end
        else
            error(args[2].." cannot be set (nil path)",0)
        end
    end
end
