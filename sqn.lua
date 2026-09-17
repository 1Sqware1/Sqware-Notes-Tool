local is_windows = package.config:sub(1,1) == "\\"
local sep = is_windows and "\\" or "/"

local home = is_windows and os.getenv("USERPROFILE") or os.getenv("HOME")

local config_dir
if is_windows then
	config_dir = os.getenv("APPDATA") .. sep .. "sqn"
else
	config_dir = home .. sep .. ".config" .. sep .. "sqn"
end

local notes_path = config_dir .. sep .. "notes.txt"


local function init_storage()
	if is_windows then 
		os.execute('if not exist "' .. config_dir .. '" mkdir "' .. config_dir .. '" 2>nul')
	else
		os.execute("mkdir -p " .. config_dir)
	end
end


local note_text = arg[1]

if note_text and note_text ~= "-l" then
	init_storage()

	local file = io.open(notes_path, "a")
	if file then

		local timestamp = os.date("%Y-%m-%d %H:%M:%S")
		file:write("[" .. timestamp .. "]" .. note_text .. "\n")
		file:close()
		print("Note has been saved! :P.")
	else
		print("T_T Error: Can`t open file for write.")
	end
	os.exit()
end


if arg[1] == "-l" then
	local file = io.open(notes_path, "r")
	if not file then 
		print("There's nothing here yet. Write something! ;P")
		os.exit()
	end

	print("--- Your Notes ---")
	for line in file:lines() do
		print(line)
	end
	file:close()
	os.exit()
end
