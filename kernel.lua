--[[
    Dawn Kernel
    By Dusk
    1.2.0
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

--peripheral drivers

k.periph = {} --peripheral drivers

function k.periph.scan(t)  --Scan peripherals. "t" is required, and defines whether to give it to a table (0), or print to standard output (1).
    local name = fs.getName(shell.getRunningProgram())
    if tonumber(t) then --tonumber() checks if param "t" is a number
        local tnt = tonumber(t) --if yeah then make the variable tnt "tonumber(t)"
        if tnt == 0 then --if 0
            local toReturn = {} --make it a table
            local per = peripheral.getNames()
                for b,v in pairs(per) do
                    local perName = peripheral.getType(v)
                    local writeThis = perName.." on "..v
                    table.insert(toReturn,writeThis)
                end
            return toReturn --give table
        elseif tnt == 1 then --if 1
            local per = peripheral.getNames()
            for b,v in pairs(per) do --print to stdout (standard output)
                local perName = peripheral.getType(v)
                local writeThis = perName.." on "..v --looks like "drive on left"
                print(writeThis)
            end
        else
            error("Driver Error (k.periph): t must be 0 or 1 (k.periph.scan(t))["..name.."]",0) --if t is not 1 or 0
        end
    else
        error("Driver Error (k.periph): t must be a number (k.periph.scan(t))["..name.."]",0) --if t is not a number
    end
end

k.periph.drive = {} --peripheral driver for disk drives

function k.periph.drive.fetch() --fetch all drives and return as a table
    local name = fs.getName(shell.getRunningProgram())
    local toReturn = {}
        local per = peripheral.getNames() --get names of peripherals attached, lets say a monitor on left, drive on right and bottom, and top modem
        for b,v in pairs(per) do --loop over
            local perName = peripheral.getType(v) --get the type
            if perName == "drive" then --filter for drives
                local writeThis = perName.." on "..v --then add to table as smn like "drive on right"
                table.insert(toReturn,writeThis)
            end
        end
    return toReturn --return the table
end

k.fs = {}

function k.fs.assignToUser(file,user)
    
end

function k.fs.whoOwns(file)
    
end

return k
