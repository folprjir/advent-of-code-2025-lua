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


local function validateEq(rhs, lhs)
  local valid = false

  local function helper(index, acc)
    if acc > rhs then return end
    if valid then return end
    if index > #lhs then
      if math.abs(acc - rhs) < 0.5 then
	valid = true
      end
      return
    end
    helper(index + 1, acc + lhs[index])
    helper(index + 1, acc * lhs[index])
    helper(index + 1, concatNumbers(acc, lhs[index]))
  end

  helper(2, lhs[1])
  return valid
end


local res = 0
for _, v in ipairs(inputs) do
  local rhs = v[1]
  table.remove(v, 1)
  local lhs = v
    if validateEq(rhs, lhs) then
      res = res + rhs
  end
end

print(res)
