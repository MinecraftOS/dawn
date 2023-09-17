--move files

local args = {...}

local function e(s)
    return s == nil or s == ""
end

if e(args[1]) then
    error("File to move must not be empty.",0)
elseif e(args[2]) then
    error("Move location must not be empty.",0)
else
    fs.copy(args[1],args[2])
end
