print("This is dijkstra")

local vertices_ = { "A", "B", "C", "D", "E", "F", "G" }

local function print_dist(vertices, d)
	local str = ""
	for _, v in ipairs(vertices) do
		str = str .. v .. " " .. d[v] .. ", "
	end
	print(str .. "\n")
end

local neighbors_ = {
	["A"] = {
		{ to = "B", price = 2 },
		{ to = "D", price = 5 },
		{ to = "F", price = 3 },
	},

	["B"] = {
		{ to = "A", price = 2 },
		{ to = "C", price = 7 },
		{ to = "E", price = 1 },
		{ to = "F", price = 4 },
	},

	["C"] = {
		{ to = "B", price = 7 },
		{ to = "E", price = 3 },
		{ to = "G", price = 4 },
	},

	["D"] = {
		{ to = "A", price = 5 },
		{ to = "E", price = 1 },
		{ to = "G", price = 1 },
	},

	["E"] = {
		{ to = "B", price = 1 },
		{ to = "C", price = 3 },
		{ to = "D", price = 1 },
		{ to = "G", price = 3 },
	},

	["F"] = {
		{ to = "A", price = 3 },
		{ to = "B", price = 4 },
	},

	["G"] = {
		{ to = "C", price = 4 },
		{ to = "D", price = 1 },
		{ to = "E", price = 3 },
	},
}

local function extract_min(queue, d)
	local min = math.huge
	local min_i = math.huge

	for i, v in ipairs(queue) do
		if min > d[v] then
			min = d[v]
			min_i = i
		end
	end

	-- print(string.format("min: %d, min_i: %d", min, min_i))
	return table.remove(queue, min_i)
end

local function dijkstra(vertices, neighbors, start, target)
	local queue = {}
	local d = {}
	for _, v in ipairs(vertices) do
		d[v] = math.huge
	end

	d[start] = 0
	queue[#queue + 1] = start

	-- print_dist(vertices, d)
	while #queue > 0 do
		local min_v = extract_min(queue, d)
		for _, n in ipairs(neighbors[min_v]) do
			if d[n.to] > d[min_v] + n.price then
				d[n.to] = d[min_v] + n.price
				queue[#queue + 1] = n.to
			end
		end
		-- print_dist(vertices, d)
	end

	return d
end

local start = "D"
local target = "F"

local d = dijkstra(vertices_, neighbors_, start, target)

local function invert_neighbors(neighbors_arr)
	local res = {}
	for _, v in ipairs(vertices_) do
		res[v] = {}
	end
	for v, neighbors in pairs(neighbors_arr) do
		for _, n in ipairs(neighbors) do
			res[n.to][#res[n.to] + 1] = { from = v, price = n.price }
		end
	end
	return res
end

local inv = invert_neighbors(neighbors_)

local path = {}
local u = target
path[1] = u

while u ~= start do
	local min_val = math.huge
	local min_v = nil
	for _, n in pairs(inv[u]) do
		if min_val > d[n.from] + n.price then
			min_val = d[n.from] + n.price
			min_v = n.from
		end
	end
	path[#path + 1] = min_v
	u = min_v
end

for _, v in ipairs(path) do
	print(v)
end
