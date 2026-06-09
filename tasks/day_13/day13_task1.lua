package.path = package.path .. ";../../utils/parsing_utils.lua"

local parsing_utils = require "parsing_utils"


print("This is day 13 task 1")


local function price(opt)
  return opt.a * 3 + opt.b
end

local function extract_nums(line)
  local nums = parsing_utils.extractNumbersFromString(line)
  return nums[1], nums[2]
end


local function find_best_combo(x, y, x1, y1, x2, y2)

  local a = x // x1
  local b = 0

  local options = {}


  ::continue::
  while a > 0 do
    local res = x - x1 * a

    if res % x2 ~= 0 then
      a = a - 1
      goto continue
    end
    b = res // x2

    if math.abs(a * y1 + b * y2 - y) < 1 then
      options[#options + 1] = { a = a, b = b }
    end

    a = a - 1
  end

  local min_price = math.huge
  local res = nil

  for _, opt in ipairs(options) do
    if price(opt) < min_price then
      res = opt
    end
  end

  return res
end


local file = io.open("./data/input.txt")
local x, y, x1, y1, x2, y2
local tokens = 0


while true do
  local line = file:read("*l")
  if line == nil then break end
  x1, y1 = extract_nums(line)
  x2, y2 = extract_nums(file:read("*l"))
  x, y = extract_nums(file:read("*l"))
  local combo = find_best_combo(x, y, x1, y1, x2, y2)
  if combo ~= nil then
    tokens = tokens + price(combo)
  end
  file:read("*l")
end


print(tokens)


