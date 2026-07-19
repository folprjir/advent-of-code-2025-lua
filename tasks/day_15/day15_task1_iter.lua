local g = {}

local path = "./data/input.txt"

local file, err = io.open(path, "r")
if not file then
	error(err)
end

local function read_line()
	return file:read("*l")
end

local function create_cell(row, col, type)
	return { row = row, col = col, type = type }
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
-- print_g()

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

--[[
local str = ""
for i = 1, #steps do
	str = str .. steps[i]
end
print("\n steps:", str)
]]

local robot_row, robot_col = 0, 0

for row = 1, max_row do
	for col = 1, max_col do
		if g[row][col] == "@" then
			robot_row, robot_col = row, col
		end
	end
end

local moves = { [">"] = { 0, 1 }, ["<"] = { 0, -1 }, ["^"] = { -1, 0 }, ["v"] = { 1, 0 } }

local function move(arr)
	if #arr < 2 then
		-- print("Array too small")
		return -1, -1
	end

	if #arr == 2 then
		-- print("Array 2 -_-_-_-_-_-_-_-")
		local first = arr[1]
		local second = arr[2]
		g[first.row][first.col] = "."
		g[second.row][second.col] = "@"
		return second.row, second.col
	end

	local first = arr[1]
	local second = arr[2]
	local last = arr[#arr]
	g[first.row][first.col] = "."
	g[second.row][second.col] = "@"
	g[last.row][last.col] = "O"

	return second.row, second.col
end

for _, step in ipairs(steps) do
	local d_row, d_col = moves[step][1], moves[step][2]
	-- print(string.format("d_row: %d, d_col: %d", d_row, d_col))

	local arr = {}
	local success = false

	local row, col = robot_row, robot_col
	while true do
		-- print(string.format("row: %d, col: %d", row, col))
		if g[row][col] == "." then
			arr[#arr + 1] = create_cell(row, col, g[row][col])
			success = true
			break
		end
		if g[row][col] == "#" then
			success = false
			break
		end
		arr[#arr + 1] = create_cell(row, col, g[row][col])
		row, col = row + d_row, col + d_col
	end

	if success then
		robot_row, robot_col = move(arr)
	end
end

-- print_g()

local sum = 0
for row = 1, max_row do
	for col = 1, max_col do
		if g[row][col] == "O" then
			sum = sum + (row - 1) * 100 + (col - 1)
		end
	end
end

print(string.format("The result is: %d", sum))
