package.path = package.path .. ";../../../utils/?.lua;../../../structures/?.lua"

local f = require "file_utils"
local pu = require "parsing_utils"
local p = require "print_utils"

local Set = require "set"

local lines = f.getLinesFromFile "./data/input.txt"

local m, short, long = pu.createMatrix(lines)


local map_of_antenas = {}

for r, row in ipairs(m) do
  for c, value in ipairs(row) do
    if value ~= "." then
      if map_of_antenas[value] == nil then
        local antenas = {{r, c}}
        map_of_antenas[value] = antenas
      else
        local arr = map_of_antenas[value]
        arr[#arr + 1] = {r, c}
      end
    end
  end
end

local rows = short
local columns = #m[1]


local function check_bounce(row, column)
  return row > rows or row < 1 or column > columns or column < 1
end


local function place_antinodes(antena_row, antena_column, vec_row, vec_column)
  local row = antena_row
  local column = antena_column
  while not check_bounce(row, column) do
    m[row][column] = "#"
    row = row + vec_row
    column = column + vec_column
  end
end


for _, antenas in pairs(map_of_antenas) do
  for antena_i, antena in pairs(antenas) do
    for ohther_i, other in pairs(antenas) do
      if antena_i ~= ohther_i then
        local dr = antena[1] - other[1]
        local dc = antena[2] - other[2]
        place_antinodes(antena[1], antena[2], dr, dc)
        place_antinodes( other[1],  other[2], -dr, -dc)
      end
    end
  end
end

local sum = 0


for row = 1, rows do
  for column = 1, columns do
    if m[row][column] == "#" then
      sum = sum + 1
    end
  end
end

print("\n")
print(sum)

