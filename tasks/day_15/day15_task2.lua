local g = {}

local path = "./data/input.txt"

local file, err = io.open(path, "r")
if not file then
	error(err)
end

local function read_line()
	local line = file:read("*l")
	return line
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
	local col = 1
	for x = 1, #line do
		local c = line:sub(x, x)
		if c == "#" then
			g[row_i][col] = "#"
			g[row_i][col + 1] = "#"
		end
		if c == "." then
			g[row_i][col] = "."
			g[row_i][col + 1] = "."
		end
		if c == "O" then
			g[row_i][col] = "["
			g[row_i][col + 1] = "]"
		end
		if c == "@" then
			g[row_i][col] = "@"
			g[row_i][col + 1] = "."
		end
		col = col + 2
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

local function find_robot(grid)
	local robot_row, robot_col = 0, 0
	for row = 1, max_row do
		for col = 1, max_col do
			if grid[row][col] == "@" then
				robot_row = row
				robot_col = col
			end
		end
	end
	return robot_row, robot_col
end

local function add(arr, seen, row, col, type)
	local will_add = false
	if seen[row] == nil then
		will_add = true
		seen[row] = {}
	end
	if seen[row][col] == nil then
		will_add = true
		seen[row][col] = true
	end
	if will_add then
		arr[#arr + 1] = create_cell(row, col, type)
		return 1
	end
	return 0
end

local function has(set, row, col)
	if set[row] == nil then
		return false
	end
	if set[row][col] == nil then
		return false
	end
	return true
end

local moves = { [">"] = { 0, 1 }, ["<"] = { 0, -1 }, ["^"] = { -1, 0 }, ["v"] = { 1, 0 } }

local function move(dir)
	local possible = true
	local seen = {}
	local arr = {}

	local robot_row, robot_col = find_robot(g)

	local d_row, d_col = moves[dir][1], moves[dir][2]
	add(arr, seen, robot_row, robot_col, g[robot_row][robot_col])

	local added_cnt = 1
	while added_cnt > 0 do
		added_cnt = 0
		for _, cell in ipairs(arr) do
			local c = g[cell.row + d_row][cell.col + d_col]
			if c == "#" then
				possible = false
				added_cnt = 0
				break
			end
			if c ~= "." then
				added_cnt = added_cnt + add(arr, seen, cell.row + d_row, cell.col + d_col, c)
			end

			if g[cell.row][cell.col] == "[" then
				added_cnt = added_cnt + add(arr, seen, cell.row, cell.col + 1, g[cell.row][cell.col + 1])
			end
			if g[cell.row][cell.col] == "]" then
				added_cnt = added_cnt + add(arr, seen, cell.row, cell.col - 1, g[cell.row][cell.col - 1])
			end
		end
	end

	if not possible then
		return g
	end

	local new_g = {}
	for row = 1, max_row do
		new_g[row] = {}
		for col = 1, max_col do
			new_g[row][col] = "."
			if not has(seen, row, col) then
				new_g[row][col] = g[row][col]
			end
		end
	end

	for _, cell in ipairs(arr) do
		new_g[cell.row + d_row][cell.col + d_col] = cell.type
	end

	return new_g
end

local c = 0
for _, dir in ipairs(steps) do
	if c == 1000 * 1000 * 1000 then
		break
	end
	g = move(dir)
	c = c + 1
end

-- print_g()

local sum = 0
for row = 1, max_row do
	for col = 1, max_col do
		if g[row][col] == "[" then
			sum = sum + (row - 1) * 100 + (col - 1)
		end
	end
end

print(string.format("The result is: %d", sum))
