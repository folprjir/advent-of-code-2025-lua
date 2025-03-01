package.path = package.path .. ";../../../utils/utils.lua"
require "utils"

local linesLoaded = GetLinesFromFile("./data/in01.txt")

local inputs = {}
for _, line in ipairs(linesLoaded) do
  table.insert(inputs, ExtractNumbers(line))
end


local function compute(lhs, operands)
  local res = 0
  if operands[1] == "+" then
    res = lhs[1] + lhs[2]
  else
    res = lhs[1] * lhs[2]
  end
  for i = 3, #lhs do
    if operands[i - 1] == "+" then
      res = res + lhs[i]
    else
      res = res * lhs[i]
    end
  end
  return res
end


local function addTimes(ops, index)
  local res = {}
  for i, v in ipairs(ops) do
    if i == index then
      table.insert(res, "*")
    else
      table.insert(res, v)
    end
  end
  return res
end


local function validateEq(eq)
  local operands = {}
  for i = 1, #eq - 2 do
    table.insert(operands, "+")
  end
  local rhs = eq[1]
  table.remove(eq, 1)
  local lhs = eq
  local valid = false

  local function helper(ops, index)
    if valid then return end
    if math.abs(rhs - compute(lhs, ops)) < 0.5 then
      valid = true
      return
    end
    if index > #ops then return end
    helper(addTimes(ops, index), index + 1)
    helper(ops, index + 1)
  end

  helper(operands, 1)
  return valid
end


local res = 0
for _, v in ipairs(inputs) do
  local val = v[1]
  if validateEq(v) then
    res = res + val
  end
end

print(res)
