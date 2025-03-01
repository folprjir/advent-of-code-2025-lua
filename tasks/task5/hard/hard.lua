package.path = package.path .. ";../../../utils/utils.lua"

require "utils"

local linesLoaded = GetLinesFromFile("./data/in01.txt")


local function createMatrix(lines)
  local m = {}
  for row, line in ipairs(lines) do
    m[row] = {}
    for col = 1, #line do
      m[row][col] = string.sub(line, col, col)
    end
  end
  return m
end


local function isMS(a, b)
  return (a == "M" and b == "S") or (a == "S" and b == "M")
end


local m = createMatrix(linesLoaded)
-- printMatrix(m)

local sum = 0
for row = 2, #m - 1 do
  for col = 2, #m[1] - 1 do
    if m[row][col] == "A" and
       isMS(m[row - 1][col - 1], m[row + 1][col + 1]) and
       isMS(m[row + 1][col - 1], m[row - 1][col + 1]) then
       sum = sum + 1
       -- print("row:", row, ", col:", col, "val:", m[row][col])
    end
  end
end

print("\nsum:", sum)



