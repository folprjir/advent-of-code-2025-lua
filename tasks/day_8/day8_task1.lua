package.path = package.path .. ";../../../utils/?.lua;../../../structures/?.lua"

local f = require "file_utils"
local pu = require "parsing_utils"
local p = require "print_utils"


local lines = f.getLinesFromFile "./data/input.txt"
local m, short, long = pu.createMatrix(lines)
local map_of_antenas = {}

for r, row in ipairs(m) do
  for c, value in ipairs(row) do
    if value ~= "." then
      if map_of_antenas[value] == nil then
        local antenas = {{r, c}}
        map_of_antenas[value] = antenas
        -- print("\nIt is nil.")
      else
        local arr = map_of_antenas[value]
        arr[#arr + 1] = {r, c}
        -- print("It is not nil.")
      end
    end
  end
end

local rows = short
local columns = #m[1]

local function place_antinode(row, column)
  if row > rows then return end
  if row < 1    then return end
  if column > columns then return end
  if column < 1       then return end

  m[row][column] = "#"
end

for type, antenas in pairs(map_of_antenas) do
  for antena_i, antena in pairs(antenas) do
    for ohther_i, other in pairs(antenas) do
      if antena_i ~= ohther_i then
        local dr = antena[1] - other[1]
        local dc = antena[2] - other[2]
        place_antinode(antena[1] + dr, antena[2] + dc)
        place_antinode( other[1] - dr,  other[2] - dc)
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

