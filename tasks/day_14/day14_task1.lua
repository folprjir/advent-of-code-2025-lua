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

for i = 1, 100 do
	-- print("iter: ", i)
	for _, r in ipairs(robots) do
		move_robot(r)
	end
end

local quadrants = { 0, 0, 0, 0 }

for _, r in ipairs(robots) do
	local x = r.p.x
	local y = r.p.y

	local half_x = max_x // 2
	local half_y = max_y // 2

	if x < half_x and y < half_y then
		quadrants[1] = quadrants[1] + 1
	end

	if x > half_x and y < half_y then
		quadrants[2] = quadrants[2] + 1
	end

	if x < half_x and y > half_y then
		quadrants[3] = quadrants[3] + 1
	end

	if x > half_x and y > half_y then
		quadrants[4] = quadrants[4] + 1
	end
end

local function mult_helper(arr, i)
	if i == #arr then
		return arr[i]
	end
	return arr[i] * mult_helper(arr, i + 1)
end

local function mult(arr)
	return mult_helper(arr, 1)
end

-- print(quadrants[1])
-- print(quadrants[2])
-- print(quadrants[3])
-- print(quadrants[4])

print("The result is: ", mult(quadrants))
