package.path = package.path .. ";../../../utils/utils.lua"
require "utils"

local linesLoaded = GetLinesFromFile("./data/in01.txt")
local m, s, l = CreateMatrix(linesLoaded)

local Dir = {
  UP = 1,
  DOWN = 2,
  LEFT = 3,
  RIGHT = 4,
}


local function createObsticle()
  return {
    up = false,
    down = false,
    left = false,
    right = false,
  }
end


local rowS, colS -- start
local rowP, colP -- position
local rows = #m
local cols = #m[1]
local dir -- direction
local dirS

for row = 1, rows do
  for col = 1, cols do
    local cell = m[row][col]
    if cell == "#" then
      m[row][col] = createObsticle()
    elseif cell ~= "." and cell ~= "#" then
      if m[row][col] == "^" then dir = Dir.UP  end
      if m[row][col] == "v" then dir = Dir.DOWN  end
      if m[row][col] == ">" then dir = Dir.RIGHT  end
      if m[row][col] == "<" then dir = Dir.LEFT end
      dirS = dir
      rowS = row
      colS = col
      rowP = row
      colP = col
    end
  end
end


local running = true

local function step()

  if dir == Dir.UP then
    if rowP == 1 then
      running = false
      return false
    end
    local cell = m[rowP - 1][colP]
    if type(cell) == "table" then
      dir = Dir.RIGHT
      if cell.up then
	return true
      else
	cell.up = true
	return false
      end
    else
      m[rowP][colP] = "X"
      rowP = rowP - 1
    end
  end

  if dir == Dir.DOWN then
    if rowP == rows then
      running = false
      return false
    end
    local cell = m[rowP + 1][colP]
    if type(cell) == "table" then
      dir = Dir.LEFT
      if cell.down then
	return true
      else
	cell.down = true
	return false
      end
    else
      m[rowP][colP] = "X"
      rowP = rowP + 1
    end
  end

  if dir == Dir.LEFT then
    if colP == 1 then
      running = false
      return false
    end
    local cell = m[rowP][colP - 1]
    if type(cell) == "table" then
      dir = Dir.UP
      if cell.left then
	return true
      else
	cell.left = true
	return false
      end
    else
      m[rowP][colP] = "X"
      colP = colP - 1
    end
  end

  if dir == Dir.RIGHT then
    if colP == cols then
      running = false
      return false
    end
    local cell = m[rowP][colP + 1]
    -- print("cell", cell, ", type", type(cell))
    if type(cell) == "table" then
      dir = Dir.DOWN
      if cell.right then
	return true
      else
	cell.right = true
	return false
      end
    else
      m[rowP][colP] = "X"
      colP = colP + 1
    end
  end
end


local function tryWithObstacleAdded(rowO, colO)
  dir = dirS
  rowP = rowS
  colP = colS
  if type(m[rowO][colO]) == "table" then
    return false
  end
  if rowO == rowS and colO == colS then
    return false
  end
  for row = 1, rows do
    for col = 1, cols do
      local cell = m[row][col]
      if type(cell) == "table" then
	cell.up = false
	cell.down = false
	cell.left = false
	cell.right = false
      end
      if cell == "X" then
	m[row][col] = "."
      end
    end
  end
  m[rowO][colO] = createObsticle()
  running = true
  while running do
    if step() then
      m[rowO][colO] = "."
      return true
    end
  end
  m[rowO][colO] = "."
  return false
end


local res = 0
for row = 1, rows do
  for col = 1, cols do
    if tryWithObstacleAdded(row, col) then
      res = res + 1
    end
  end
end

print("Final result:", res)
