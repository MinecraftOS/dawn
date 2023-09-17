local args = {...}

if args[1] == "-h" then
    print("pwd prints the current working directory.")
elseif shell.dir() == "" then
    print("/")
else
    print("/"..shell.dir().."/")
end
