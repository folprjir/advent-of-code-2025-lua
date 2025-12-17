package.path = package.path .. ";../../../utils/utils.lua"
require "utils"

local linesLoaded = GetLinesFromFile("./data/in01.txt")

local inputs = {}
for _, line in ipairs(linesLoaded) do
  table.insert(inputs, ExtractNumbersFromString(line))
end


local function concatNumbers(n1, n2)
  local numOfDigits = math.floor(math.log10(n2)) + 1
  local res = n1 * 10 ^ numOfDigits + n2
  return res
end


local function compute(lhs, operands)
  local res = 0
  if operands[1] == "*" then
    res = lhs[1] * lhs[2]
  elseif operands[1] == "@" then
    res = concatNumbers(lhs[1], lhs[2])
  else
    res = lhs[1] + lhs[2]
  end
  for i = 3, #lhs do
    if operands[i - 1] == "*" then
      res = res * lhs[i]
    elseif operands[i - 1] == "@" then
      res = concatNumbers(res, lhs[i])
    else
      res = res + lhs[i]
    end
  end
  return res
end


local function addOp(ops, op, index)
  local res = {}
  for i, v in ipairs(ops) do
    if i == index then
      table.insert(res, op)
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
    helper(addOp(ops, "*", index), index + 1)
    helper(addOp(ops, "@", index), index + 1)
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
