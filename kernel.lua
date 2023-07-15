--[[
    Dawn Kernel
    By Dusk
    1.0.0-idev1
]]

local handle

local n

local function isempty(s) --i robbed this from https://stackoverflow.com/questions/19664666/check-if-a-string-isnt-nil-or-empty-in-lua
    return s == nil or s == ''
end

local function PANIC(desc,code)
    local pCode = tonumber(code)
    local c = os.clock()
    if pCode then
        print("")
        print("!!! DAWN - KERNEL PANIC !!!")
        print("Runtime until call:",c.."s")
        print("Provided reason:",desc)
        print("System will restart in 10 seconds to attempt to fix the issue.")
        print("Error code:",code)
        sleep(10)
        os.reboot()
    else
        print("")
        print("!!! DAWN - KERNEL PANIC !!!")
        print("Runtime until call:",c.."s")
        print("Provided reason:",desc)
        print("System will restart in 10 seconds to attempt to fix the issue.")
        sleep(10)
        os.reboot()
    end
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
            elseif type == 2 then
                write("("..name.."):[")
                term.setTextColor(colors.yellow)
                write("WARN")
                term.setTextColor(colors.white)
                write("]:"..msg.."("..err..")\n")
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

return k