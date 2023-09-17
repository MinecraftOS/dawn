--[[
    Specialized io lib
    By Dusk
    For general io such as y/n answers, and pauses
]]

local function e(s)
    return s == nil or s == ""
end

local i = {}

function i.pause(msg) --pauses operation with (a by default) "Press any key to continue..." prompt if the "msg" field is blank.
    if e(msg) then
        print("Press any key to continue...")
        while true do
            local event = {os.pullEvent()}
            local eventD = event[1]
        
            if eventD == "key" then
                break
            end
        end
    else
        print(msg)
        while true do
            local event = {os.pullEvent()}
            local eventD = event[1]
        
            if eventD == "key" then
                break
            end
        end
    end
end

i.ynae = {} --yes/no answers

function i.ynae.nopref() --presents a yes/no answer prompt with no preference
    local yn
    write("[y/n]:")
    while true do
        local event = {os.pullEvent()}
        local eventD = event[1]
    
        if eventD == "key" then
            local k = event[2]
            if k == keys.y then
              write("y")
              yn = true
              break
            elseif k == keys.n then
                write("n")
                yn = false
                break
            end
        end
    end
    return yn
end

function i.ynae.ypref() --presents a yes/no answer prompt with yes as the default
    local yn
    write("[Y/n]:")
    while true do
        local event = {os.pullEvent()}
        local eventD = event[1]
    
        if eventD == "key" then
            local k = event[2]
            if k == keys.y then
              write("y\n")
              yn = true
              break
            elseif k == keys.n then
                write("n\n")
                yn = false
                break
            end
        else
            write("y\n")
            yn = true
            break
        end
    end
    return yn
end

function i.ynae.npref() --presents a yes/no answer prompt with no as default
    local yn
    write("[y/N]:")
    while true do
        local event = {os.pullEvent()}
        local eventD = event[1]
    
        if eventD == "key" then
            local k = event[2]
            if k == keys.y then
              write("y")
              yn = true
              break
            elseif k == keys.n then
                write("n")
                yn = false
                break
            end
        else
            write("n")
            yn = false
            break
        end
    end
    return yn
end

return i
