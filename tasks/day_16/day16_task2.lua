local g = {}

local path = "./data/input.txt"

local file, err = io.open(path, "r")
if not file then
	error(err)
end

local function read_line()
	return file:read("*l")
end

local row_i = 1
while true do
	local line = read_line()
	if not line then
		break
	end
	g[row_i] = {}
	for col_i = 1, #line do
		g[row_i][col_i] = line:sub(col_i, col_i)
	end
	row_i = row_i + 1
end

file:close()

local rows, cols = #g, #g[1]

local start_row, start_col, end_row, end_col = 0, 0, 0, 0
for row = 1, rows do
	for col = 1, cols do
		if g[row][col] == "S" then
			start_row, start_col = row, col
			g[row][col] = "."
		end
		if g[row][col] == "E" then
			end_row, end_col = row, col
			g[row][col] = "."
		end
	end
end

local dirs = { ">", "<", "v", "^" }
local moves = { [">"] = { 0, 1 }, ["<"] = { 0, -1 }, ["v"] = { 1, 0 }, ["^"] = { -1, 0 } }

print(string.format("rows: %d, cols: %d", #g, #g[1]))

local function update_dist(d, v, price)
	if d[v.row] == nil then
		d[v.row] = {}
	end
	if d[v.row][v.col] == nil then
		d[v.row][v.col] = {}
	end
	if d[v.row][v.col][v.dir] == nil or d[v.row][v.col][v.dir] > price then
		d[v.row][v.col][v.dir] = price
	end
end

local function get_dist(d, v)
	if d[v.row] == nil then
		return math.huge
	end
	if d[v.row][v.col] == nil then
		return math.huge
	end
	if d[v.row][v.col][v.dir] == nil then
		return math.huge
	end
	return d[v.row][v.col][v.dir]
end

local function extract_min(queue, d)
	local min = math.huge
	local min_i = math.huge

	for i, v in ipairs(queue) do
		local dist = get_dist(d, v)
		if dist == nil then
			print("dist is nil")
		end
		if dist ~= nil and dist < min then
			min = dist
			min_i = i
		end
	end

	return table.remove(queue, min_i)
end

local function get_dist_to_next(old_dir, new_dir)
	if old_dir == new_dir then
		return 1
	end
	if old_dir == "^" or old_dir == "v" then
		if new_dir == ">" or new_dir == "<" then
			return 1001
		end
	elseif old_dir == ">" or old_dir == "<" then
		if new_dir == "^" or new_dir == "v" then
			return 1001
		end
	end
	return 2001
end

local function get_neighbors(v)
	local res = {}
	for _, dir in pairs(dirs) do
		local n_row, n_col = v.row + moves[dir][1], v.col + moves[dir][2]
		if g[n_row][n_col] == "." then
			res[#res + 1] = { row = n_row, col = n_col, dir = dir, dist = get_dist_to_next(v.dir, dir) }
		end
	end
	return res
end

local function dijkstra()
	local queue = {}
	local d = {} -- d[row][col][dir] -> dist

	local first = { row = start_row, col = start_col, dir = ">" }
	update_dist(d, first, 0)
	queue[#queue + 1] = first

	while #queue > 0 do
		local min_v = extract_min(queue, d)
		-- print_v(d, min_v)
		for _, n in ipairs(get_neighbors(min_v)) do
			-- if d[n.to] > d[min_v] + n.price then
			local new_dist = get_dist(d, min_v) + n.dist
			if get_dist(d, n) > new_dist then
				update_dist(d, n, new_dist)
				queue[#queue + 1] = n
			end
		end
	end

	return d
end

local distances = dijkstra()

-- Task 2 -----------------------------------------------------------------------

local function turn_factor(old_dir, new_dir)
	if old_dir == new_dir then
		return 0
	end
	if old_dir == ">" or old_dir == "<" then
		if new_dir == "^" or new_dir == "v" then
			return 1000
		end
	end
	if old_dir == "^" or old_dir == "v" then
		if new_dir == ">" or new_dir == "<" then
			return 1000
		end
	end
	return 2000
end

local function get_shotest_dist(d, row, col, old_dir)
	local all_new_dirs = {}
	local min = math.huge
	for _, dir in ipairs(dirs) do
		local dist = get_dist(d, { row = row, col = col, dir = dir }) + turn_factor(old_dir, dir)
		if dist <= min then
			min = dist
			all_new_dirs[#all_new_dirs + 1] = { dir = dir, dist = dist }
		end
	end

	local best_new_dirs = {}

	for _, dir in ipairs(all_new_dirs) do
		if dir.dist == min then
			best_new_dirs[#best_new_dirs + 1] = dir.dir
		end
	end

	return min, best_new_dirs
end

local function get_best_neighbors(d, row, col, old_dir)
	local all_n = {}
	local min, _ = get_shotest_dist(d, row, col, old_dir)

	for _, dir in pairs(dirs) do
		local n_row, n_col = row + moves[dir][1], col + moves[dir][2]
		if g[n_row][n_col] ~= "#" then
			local dist, new_dirs = get_shotest_dist(d, n_row, n_col, old_dir)
			for _, new_dir in ipairs(new_dirs) do
				all_n[#all_n + 1] = { row = n_row, col = n_col, dir = new_dir, dist = dist }
			end
			if dist < min then
				min = dist
			end
		end
	end

	local best_n = {}

	for _, n in ipairs(all_n) do
		if n.dist == min then
			best_n[#best_n + 1] = n
		end
	end

	return best_n
end

local function mark_shortest(d, v)
	if v.row == start_row and v.col == start_col then
		g[start_row][start_col] = "O"
		return
	end
	local best_n = get_best_neighbors(d, v.row, v.col, v.dir)
	for _, n in ipairs(best_n) do
		mark_shortest(d, n)
	end
	g[v.row][v.col] = "O"
end

mark_shortest(distances, { row = end_row, col = end_col, dir = "v" })

local g_str = ""
for row = 1, rows do
	for col = 1, cols do
		g_str = g_str .. g[row][col]
	end
	g_str = g_str .. "\n"
end

print(g_str)

local sum = 0

for row = 1, rows do
	for col = 1, cols do
		if g[row][col] == "O" then
			sum = sum + 1
		end
	end
end

print(sum)
