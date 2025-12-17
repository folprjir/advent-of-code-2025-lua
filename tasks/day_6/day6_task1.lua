package.path = package.path .. ";../../../utils/utils.lua"

require "utils"

local linesLoaded = GetLinesFromFile("./data/in01.txt")

local m, s, l = CreateMatrix(linesLoaded)

-- print("s:", s, ", l:", l, ", rows:", #m)

local Dir = {
  UP = 1,
  DOWN = 2,
  LEFT = 3,
  RIGHT = 4,
}

local rowP, colP
local rows = #m
local cols = #m[1]
local dir


for row = 1, rows do
  for col = 1, cols do
    local cell = m[row][col]
    if cell ~= "." and cell ~= "#" then
      if m[row][col] == "^" then dir = Dir.UP  end
      if m[row][col] == "v" then dir = Dir.DOWN  end
      if m[row][col] == ">" then dir = Dir.LEFT  end
      if m[row][col] == "<" then dir = Dir.RIGHT end
      rowP = row
      colP = col
      break
    end
  end
end


m[rowP][colP] = "X"
local running = true


local function step()

  if dir == Dir.UP then
    if rowP == 1 then
      running = false
      return
    elseif m[rowP - 1][colP] == "#" then
      dir = Dir.RIGHT
      return
    else
      rowP = rowP - 1
    end
  end

  if dir == Dir.DOWN then
    if rowP == rows then
      running = false
      return
    elseif m[rowP + 1][colP] == "#" then
      dir = Dir.LEFT
      return
    else
      rowP = rowP + 1
    end
  end

  if dir == Dir.LEFT then
    if colP == 1 then
      running = false
      return
    elseif m[rowP][colP - 1] == "#" then
      dir = Dir.UP
      return
    else
      colP = colP - 1
    end
  end

  if dir == Dir.RIGHT then
    if colP == cols then
      running = false
      return
    elseif m[rowP][colP + 1] == "#" then
      dir = Dir.DOWN
      return
    else
      colP = colP + 1
    end
  end

  m[rowP][colP] = "X"
end

while running do
  -- PrintMatrix(m) print("----")
  step()
end


local res = 0
for row = 1, rows do
  for col = 1, cols do
    if m[row][col] == "X" then
      res = res + 1
    end
  end
end


-- PrintMatrix(m) print("----")
print("The result is:", res)

