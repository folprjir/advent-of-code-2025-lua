print("This is day 10, part 1")

local path = "./data/input01.txt"
local file = io.open(path, "r")
local file_content = nil

if file then
  file_content = file:read("*a")
  file:close()
else
  assert(false, string.format("Failed to open file: %s", path))
end

local topography_map = {}
local t_row = {}
for char in file_content:gmatch(".") do
  if char == "\n" then
    topography_map[#topography_map + 1] = t_row
    t_row = {}
  else
    t_row[#t_row + 1] = tonumber(char)
  end
end

local rows_cnt = #topography_map
local cols_cnt = #topography_map[1]
local steps = {{-1, 0}, {1, 0}, {0, -1}, {0, 1}}
local trails_cnt = 0
local visited_map = {}

local function was_visited(row, col)
  local m = visited_map[row]
  if m then
    local val = m[col]
    if val then
      return true
    end
  end
  return false
end

local function add_visited(row, col)
  local m = visited_map[row]
  if m then
    m[col] = true
  else
    visited_map[row] = {}
    visited_map[row][col] = true
  end
end

local function count_trails(row, col, height)
  if topography_map[row][col] == 9 then
    if not was_visited(row, col) then
      trails_cnt = trails_cnt + 1
      add_visited(row, col)
    end
    return
  end
  for _, s in ipairs(steps) do
    local r = row + s[1]
    local c = col + s[2]
    if not (r == 0 or r > rows_cnt or
            c == 0 or c > cols_cnt) then
      if topography_map[r][c] == height + 1 then
        count_trails(r, c, height + 1)
      end
    end
  end
end

for row = 1, #topography_map do
  for col = 1, #topography_map[row] do
    if topography_map[row][col] == 0 then
      visited_map = {}
      count_trails(row, col, 0)
    end
  end
end

print(string.format("There is exactly %d trails", trails_cnt))
