package.path = package.path .. ";../../utils/parsing_utils.lua"
local parsing_utils = require("parsing_utils")

local max_x = 101
local max_y = 103

local function create_robot(px, py, vx, vy)
	return { p = { x = px, y = py }, v = { x = vx, y = vy } }
end

local function wrap(val, max)
	if val >= max then
		while val >= max do
			val = val - max
		end
		return val
	end
	if val < 0 then
		while val < 0 do
			val = val + max
		end
	end
	return val
end

local function move_robot(r)
	local p = r.p
	local v = r.v
	p.x = wrap(p.x + v.x, max_x)
	p.y = wrap(p.y + v.y, max_y)
end

local lines = io.lines("./data/input.txt")

local robots = {}

for line in lines do
	local nums = parsing_utils.extractNumbersFromString(line)
	robots[#robots + 1] = create_robot(nums[1], nums[2], nums[3], nums[4])
end

local function add(set, x, y)
	if set[x] == nil then
		set[x] = {}
	end
	set[x][y] = true
end

local function has(set, x, y)
	if set[x] == nil then
		return false
	end
	if set[x][y] == nil then
		return false
	end
	return set[x][y]
end

local res = -111
for i = 1, 1000000 do
	for _, r in ipairs(robots) do
		move_robot(r)
	end

	local set = {}
	local coli = 0
	for _, r in ipairs(robots) do
		if has(set, r.p.x, r.p.y) then
			coli = coli + 1
		end
		add(set, r.p.x, r.p.y)
	end
	print("coli: ", coli, i)
	if coli == 0 then
		res = i
		goto finnish
	end
end

::finnish::
print(res)

local grid = {}

for x = 0, max_x do
	grid[x] = {}
	for y = 0, max_y do
		grid[x][y] = " "
	end
end

for _, r in ipairs(robots) do
	grid[r.p.x][r.p.y] = "#"
end

local str = ""
for y = 0, max_y do
	str = str .. "\n"
	for x = 0, max_x do
		str = str .. grid[x][y]
	end
end

print(str)
