local tmp = fs.list("/tmp/")
local vdump = fs.list("/var/dump/")
local edump = fs.list("/etc/dump/")
local function e(s)
    return s == nil or s == ""
end

if e(tmp[1]) ~= true then
    fs.delete("/tmp/*")
end

if e(vdump[1]) ~= true then
    fs.delete("/var/dump/*")
end

if e(edump[1]) ~= true then
    fs.delete("/etc/dump/*")
end
