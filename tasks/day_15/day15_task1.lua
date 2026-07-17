local g = {}

local path = "./data/input.txt"

local file, err = io.open(path, "r")
if not file then
	error(err)
end

local function read_line()
	return file:read("*l")
end

local row_i = 0
while true do
	local line = read_line()
	if line == "" then
		break
	end

	row_i = row_i + 1
	g[row_i] = {}
	for col = 1, #line do
		g[row_i][col] = line:sub(col, col)
	end
end

local max_row = row_i
local max_col = #g[1]

-- print(string.format("rows: %d, colums: %d", max_row, max_col))

local function print_g()
	local str = ""
	for row = 1, max_row do
		str = str .. "\n"
		for col = 1, max_col do
			str = str .. g[row][col]
		end
	end
	print(str)
end

print_g()

local steps = {}
while true do
	local line = read_line()
	if not line then
		break
	end
	for i = 1, #line do
		steps[#steps + 1] = line:sub(i, i)
	end
end

file:close()

local str = ""
for i = 1, #steps do
	str = str .. steps[i]
end

print("\n steps:", str)

local robot_row, robot_col = 0, 0

for row = 1, max_row do
	for col = 1, max_col do
		if g[row][col] == "@" then
			robot_row = row
			robot_col = col
		end
	end
end

local function move(dir, row, col)
	local new_row, new_col = row, col
	if dir == ">" then
		-- print("moovin right")
		new_col = col + 1
	end
	if dir == "<" then
		--print("moovin left")
		new_col = col - 1
	end
	if dir == "v" then
		-- print("moovin down")
		new_row = row + 1
	end
	if dir == "^" then
		-- print("moovin up")
		new_row = row - 1
	end
	-- print("movin to:", new_row, new_col)
	return new_row, new_col
end

local function move_back(dir, row, col)
	local new_row, new_col = row, col
	if dir == ">" then
		-- print("swapin right")
		new_col = col - 1
	end
	if dir == "<" then
		-- print("swapin left")
		new_col = col + 1
	end
	if dir == "v" then
		-- print("swapin down")
		new_row = row - 1
	end
	if dir == "^" then
		-- print("swapin up")
		new_row = row + 1
	end
	-- print("swapin to:", new_row, new_col)
	return new_row, new_col
end

local function swap(dir, row, col)
	local new_row, new_col = move_back(dir, row, col)
	local tmp = g[row][col]
	g[row][col] = g[new_row][new_col]
	g[new_row][new_col] = tmp
end

local function move_robot(dir, row_, col_)
	local success = false
	local new_robot_row, new_robot_col = row_, col_

	local function inner(row, col)
		-- print(string.format("dir %s, row: %d, col: %d", dir, row, col))
		local c = g[row][col]
		if c == "#" then
			success = false
			return
		end
		if c == "." then
			success = true
			return
		end
		row, col = move(dir, row, col)
		inner(row, col)
		if success then
			-- print("swapin")
			swap(dir, row, col)
			new_robot_row, new_robot_col = row, col
		else
			-- print("no swapin :(")
		end
	end

	inner(row_, col_)
	-- print("new_row", new_robot_row, "new_col", new_robot_col)
	return new_robot_row, new_robot_col
end

for i = 1, #steps do
	robot_row, robot_col = move_robot(steps[i], robot_row, robot_col)
	-- print_g()
end

local sum = 0
for row = 1, max_row do
	for col = 1, max_col do
		if g[row][col] == "O" then
			sum = sum + (row - 1) * 100 + (col - 1)
		end
	end
end
print(sum)

--[[
robot_row, robot_col = move_robot("^", robot_row, robot_col)
print_g()
robot_row, robot_col = move_robot("^", robot_row, robot_col)
print_g()
robot_row, robot_col = move_robot(">", robot_row, robot_col)
print_g()
robot_row, robot_col = move_robot(">", robot_row, robot_col)
print_g()
robot_row, robot_col = move_robot("v", robot_row, robot_col)
print_g()
]]
