package.path = package.path .. ";../../utils/?.lua;../../structures/?.lua"

local p = require "print_utils"
local f = require "file_utils"

local test1 = "12345"
local test2 = "2333133121414131402"

local packed = f.loadFile("./data/input.txt")


local unpacked = {}


for i = 1, #packed do
  local n = tonumber(packed:sub(i, i))

  if not n then break end

  if i % 2 == 1 then
    for _ = 1, n do
      unpacked[#unpacked + 1] = math.floor(i / 2)
    end
  else
    for _ = 1, n do
      unpacked[#unpacked + 1] = "."
    end
  end
  -- p.printArray(unpacked)
end

local head = 1
local tail = #unpacked

while unpacked[head] ~= "." do head = head + 1 end

while head ~= tail do
  if unpacked[head] ~= "." then
    head = head + 1
    goto continue
  end
  if unpacked[tail] == "." then
    tail = tail - 1
    goto continue
  end

  local tmp = unpacked[head]
  unpacked[head] = unpacked[tail]
  unpacked[tail] = tmp
  head = head + 1
  tail = tail - 1
  ::continue::
end


local check_sum = 0

for i, id in ipairs(unpacked) do
  if id == "." then
    break
  end
  check_sum = check_sum + (i - 1) * id
end

p.printArray(unpacked)
print(check_sum)
