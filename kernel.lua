--[[
    YABADEV Kernel
    1.1.0R
]]

local handle

local n

local function isempty(s) --i robbed this from https://stackoverflow.com/questions/19664666/check-if-a-string-isnt-nil-or-empty-in-lua
    return s == nil or s == ''
end

local k = {}

function k.empty(s) --see line 11
    return s == nil or s == ""
end

function k.scrMSG(type,msg,err) --type: 1,2,3,4,5 (see docs); msg: message; err: error code
    local name = fs.getName(shell.getRunningProgram())
    if isempty(err) then
        if type == 1 then
            write("("..name.."):[")
            term.setTextColor(colors.green)
            write("OK")
            term.setTextColor(colors.white)
            write("]:"..msg.."\n")
        elseif type == 2 then
            write("("..name.."):[")
            term.setTextColor(colors.yellow)
            write("WARN")
            term.setTextColor(colors.white)
            write("]:"..msg.."\n")
        elseif type == 3 then
            write("("..name.."):[")
            term.setTextColor(colors.brown)
            write("INFO")
            term.setTextColor(colors.white)
            write("]:"..msg.."\n")
        elseif type == 4 then
            printError("("..name.."):[ ERROR ]:"..msg)
        elseif type == 5 then
            printError("("..name.."):[ ERROR ]:"..msg)
            error()
        end
    else
        local errNum = tonumber(err)
        if errNum then
            if type == 1 then
                write("("..name.."):[")
                term.setTextColor(colors.green)
                write("OK")
                term.setTextColor(colors.white)
                write("]:"..msg.."("..err..")\n")
                term.setTextColor(colors.yellow)
                write("WARN")
                term.setTextColor(colors.white)
                write("]:"..msg.."("..err..")\n")
            elseif type == 2 then
                write("("..name.."):[")
            elseif type == 3 then
                write("("..name.."):[")
                term.setTextColor(colors.brown)
                write("INFO")
                term.setTextColor(colors.white)
                write("]:"..msg.."("..err..")\n")
            elseif type == 4 then
                printError("("..name.."):[ ERROR ]:"..msg.."(code:"..err..")")
            elseif type == 5 then
                printError("("..name.."):[ ERROR ]:"..msg.."(code:"..err..")")
                error()
            end
        else
            if type == 1 then
                write("("..name.."):[")
                term.setTextColor(colors.green)
                write("OK")
                term.setTextColor(colors.white)
                write("]:"..msg.."\n")
            elseif type == 2 then
                write("("..name.."):[")
                term.setTextColor(colors.yellow)
                write("WARN")
                term.setTextColor(colors.white)
                write("]:"..msg.."\n")
            elseif type == 3 then
                write("("..name.."):[")
                term.setTextColor(colors.brown)
                write("INFO")
                term.setTextColor(colors.white)
                write("]:"..msg.."\n")
            elseif type == 4 then
                printError("("..name.."):[ ERROR ]:"..msg)
            elseif type == 5 then
                printError("("..name.."):[ ERROR ]:"..msg)
                error()
            end
        end
        
    end
end

function k.isColor(a)
    return a == "white" or a == "orange" or a == "magenta" or a == "lime" or a == "pink" or a == "gray" or a == "cyan" or a == "brown" or a == "blue" or a == "green"
end

function k.isSide(a)
    return a == "bottom" or a == "top" or a == "left" or a == "right" or a == "back" or a == "front"
end

oldfs = {}
for i, v in pairs(fs) do
    oldfs[i] = v
end
kfs = {}

function kfs.fsCheck() --check filesystem for all components
    
end

function kfs.listPerms(file)
	function testing()
    local filePerms = dofile("/.fp")
	end
	status, ret = xpcall (testing, debug.traceback)

	print (status)
	print (ret)
    data = {}
    if filePerms and filePerms[file] then
        for i, v in pairs(filePerms[file]) do
            local level = string.sub(i, 1, 1)
            local user = string.sub(i, 2)
            data[user] = level
        end
    end

    return data
end

function kfs.editPerms(file, user, level)
    if type(level) ~= "number" then
        k.scrMSG(4, "kfs.editPerms", "Level must be integer")
        return false
    end
    local handle = oldfs.open("/etc/usr/.login","r")
    local currentUser = handle.readLine()
    handle.close()
    local filePerms = dofile("/.fp")
    if filePerms == nil then
        filePerms = {}
    end
    if filePerms[file] == nil then
        filePerms[file] = {}
    end
    if currentUser == "root" then
        filePerms[file][user] = level
        file = oldfs.open("/.fp", "w")
        file.write(textutils.serialize(filePerms))
        file.close()
    else
        perms = kfs.listPerms(file)
        if perms[currentUser] == nil or perms[currentUser] == 0 or perms[currentUser] == 1 then
            errorthing = "Permission not granted to edit file permissions on " .. file
            k.scrMSG(4, "kfs.editPerms", errorthing)
        else
            filePerms[file][user] = level
            file = oldfs.open("/.fp", "w")
            file.write(textutils.serialize(filePerms))
            file.close()
        end
    end
end

function kfs.setOwner(file, user, newLevel)
    if type(newLevel) ~= "number" then
        k.scrMSG(4, "kfs.setOwner", "newLevel must be integer")
        return false
    end
    if filePerms == nil then
        filePerms = {}
    end
    if filePerms[file] == nil then
        filePerms[file] = {}
    end
    perms = kfs.listPerms(file)
    local handle = oldfs.open("/etc/usr/.login","r")
    local currentUser = handle.readLine()
    handle.close()
    if perms[currentUser] == "owner" then
        filePerms[file][currentUser] = newLevel
        filePerms[file][user] = "owner"
        file = oldfs.open("/.fp", "w")
        file.write(textutils.serialize(filePerms))
        file.close()
    else
        k.scrMSG(4, "kfs.setOwner", "You are not allowed to setOwner")
        return false
    end
end

function kfs.open(path, mode)
    handle = assert(oldfs.open("/etc/usr/.login", "r"))
    usr = handle.readLine()
    handle.close()
    path = fs.combine(path)
    if path == ".fp" or path == "startup.lua" or path == "kernel.lua" or path == "bin/login.lua" or path == "etc/usr/.login" then
        if usr == "root" then
            return assert(oldfs.open(path, mode))
        else
            k.scrMSG(4, "kfs.open", "root required to edit or read protected files")
            return false
        end
    else
        if usr == "root" then
            return assert(oldfs.open(path, mode))
        else
            perms = kfs.listPerms(path)
            level = perms[usr]
            if level == 0 or level == nil then
                k.scrMSG(4, "kfs.open", "no permission to edit or read file")
                return false
            else
                if mode == "r" then
                    if level == 1 or level == 2 or level == "owner" then
                        return assert(oldfs.open(path, "r"))
                    else
                        return false
                    end
				end
                if mode == "w" or mode == "a" or mode == "r+" or mode == "w+" or mode == "a+" then
                    if level == 2 or level == "owner" then
                        return assert(oldfs.open(path, mode))
                    else
                        k.scrMSG(4, "kfs.open", "no permission to edit file")
                    end
                end
            end
        end
    end
end

function kfs.move(path, dest)
    handle = assert(oldfs.move("/etc/usr/.login", "r"))
    usr = handle.readLine()
    handle.close()
    path = fs.combine(path)
    if path == ".fp" or path == "startup.lua" or path == "kernel.lua" or path == "bin/login.lua" or path == "etc/usr/.login" then
        if usr == "root" then
            return assert(oldfs.move(path, mode))
        else
            k.scrMSG(4, "kfs.move", "root required to move protected files")
            return false
        end
    else
        if usr == "root" then
            return assert(oldfs.move(path, mode))
        else
            perms = kfs.listPerms(path)
            level = perms[usr]
            if level == 2 or level == "owner" then
                return assert(oldfs.move(path, mode))
            else
                k.scrMSG(4, "kfs.move", "no permission to move file")
            end
        end
    end
end

_G.fs.fsCheck = kfs.fsCheck
_G.fs.listPerms = kfs.listPerms
_G.fs.editPerms = kfs.editPerms
_G.fs.setOwner = kfs.setOwner
_G.fs.move = kfs.move
_G.fs.open = kfs.open

custom = {}

function custom.findCenter(str,centerVert,customY)
    local MX,MY = term.getSize()
    local X = (MX/2)-(string.len(str)/2)
    if centerVert then
        term.setCursorPos(X,MY/2)
    else
        term.setCursorPos(X,customY)
    end
    return true
end

function custom.printCenter(str,centerVert,customY)
    local MX,MY = term.getSize()
    local X = (MX/2)-(string.len(str)/2)
    if centerVert then
        term.setCursorPos(X,MY/2)
    else
        term.setCursorPos(X,customY)
    end
    print(str)
    return true
end

function custom.findCenter2(str)
    local MX,MY = term.getSize()
    local X = (MX/2)-(string.len(str)/2)
    return X
end

function custom.PIDrun(prior_error, prior_integral, kp, ki, kd, bias, set, currentval)
    function pidrun()
        errorc = set - currentval
        integral = integral_prior+errorc
        derivative = errorc-error_prior

        value_out = kp*errorc+ki*integral+kd*derivative+bias
    end
    if pcall(pidrun) then
        return value_out, errorc, integral
    else
        k.scrMSG(4, "kernel[PIDrun]", "An error occured when attempting to run PID")
        return false
    end
end

_G.dawn = {}
_G.dawn.findCenter = custom.findCenter
_G.dawn.printCenter = custom.printCenter
_G.dawn.PIDrun = custom.PIDrun

return k