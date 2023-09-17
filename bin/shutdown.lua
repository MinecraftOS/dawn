--shutdown command

local args = {...}

local function e(s)
    return s == "" or s == nil
end

if args[1] == "-h" then
    print([[
Default behavior is shutdown the system.
Additional args:
shutdown -r | reboot the system
shutdown <time> | time before the action occurs.
    ]])
elseif e(args[1]) then
    print("Shutting down.")
    print("Clearing user session data...")
    fs.delete("/etc/usr/.login")
    print("Done.")
    sleep(1)
    os.shutdown()
elseif args[1] == "-r" then
    print("Shutting down.")
    print("Clearing user session data...")
    fs.delete("/etc/usr/.login")
    print("Done.")
    if e(args[2]) then
        sleep(1)
    else
        if tonumber(args[2]) then
            print("Waiting "..args[2].." seconds.")
            local z = tonumber(args[2])
            sleep(z)
        end
    end
    os.reboot()
end