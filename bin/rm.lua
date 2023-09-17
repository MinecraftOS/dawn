--remove files, dirs, etc
--idc, people can delete their entire system if they want. This is what I will now be calling a "nuke" program
--meaning that if used incorrectly, it can nuke the system :D

local args = {...}

if args[1] == "-h" then
    print("rm - remove files and directories")
    print("(must be run with sudo, mind you (sudo rm <file/-rf <dir))")
    print("rm <file> - remove a file")
    print("rm -rf <dir> - remove a dir")
end

if fs.exists("/tmp/sudo") then --if sudo was called
    fs.delete("/tmp/sudo")
    
    if args[1] == "-rf" then --check for the -rf flag (rm -rf <dir>)
        if fs.exists(args[2]) then
            if fs.isDir(args[2]) then
                fs.delete(args[2])
            else
                error(args[2].." is not a path.",0)
            end
        else
            error(args[2].." is not a path.",0)
        end
    else
        if fs.exists(args[1]) then
            if fs.isDir(args[1]) then
                error(args[1].." is a dir, not a file. use the -rf flag.")
            else
                fs.delete(args[1])
            end
        else
            error(args[1].." does not exist.",0)
        end
    end
else
    error("rm must be run with sudo.",0)
end
