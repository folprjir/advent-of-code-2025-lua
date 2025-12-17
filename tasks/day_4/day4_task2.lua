package.path = package.path .. ";../../../utils/utils.lua"

require "utils"

local linesLoaded = GetLinesFromFile("./data/in01.txt")




local function isMS(a, b)
  return (a == "M" and b == "S") or (a == "S" and b == "M")
end


local m = CreateMatrix(linesLoaded)
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



