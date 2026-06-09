package.path = package.path .. ";../../utils/parsing_utils.lua"
local parsing_utils = require "parsing_utils"
print("This is day 13 task 2")


local function price(opt)
  return opt.a * 3 + opt.b
end


local function extract_nums(line)
  local nums = parsing_utils.extractNumbersFromString(line)
  return nums[1], nums[2]
end


local function round(num)
  return math.floor(num + 0.5)
end


local function find_best_combo(b1, b2, x1, x2, y1, y2)
  local a = (b2 * x2 - b1 * y2) / (x2 * y1 - x1 * y2)
  local b = (b1 - a * x1) / x2
  a = round(a)
  b = round(b)
  if a * x1 + b * x2 ~= b1 or
     a * y1 + b * y2 ~= b2 then
    return nil
  end
  return {a = a , b = b}
end


local file = io.open("./data/input.txt")
local b1, b2, x1, x2, y1, y2
local tokens = 0
while true do
  local line = file:read("*l")
  if line == nil then break end
  x1, y1 = extract_nums(line)
  x2, y2 = extract_nums(file:read("*l"))
  b1, b2 = extract_nums(file:read("*l"))
  local combo = find_best_combo(
    b1 + 10000000000000,
    b2 + 10000000000000,
    x1, x2, y1, y2)
  if combo ~= nil then
    tokens = tokens + price(combo)
  end
  file:read("*l")
end

file:close()

print(tokens)
