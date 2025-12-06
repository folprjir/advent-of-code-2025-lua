package.path = package.path .. ";../../utils/?.lua;../../structures/?.lua"

local p = require "print_utils"
local f = require "file_utils"

local test1 = "2222222"
local test2 = "2333133121414131402"
local test3 = "22233344411111112"
local test4 = "90909"
local test5 = "12345"
local test6 = "1530111"

local packed = f.loadFile("./data/input.txt")


local function create_segment(id, begin, size)
  return {id=id, begin=begin, size=size}
end

local free_spaces = {}
local files = {}

local id = 0
local begin = 1

for i = 1, #packed do
  local n = tonumber(packed:sub(i, i))
  if n == nil or n == 0 then
    goto continue
  end
  if i % 2 == 1 then
    files[#files+1] = create_segment(id, begin, n)
    id = id + 1
  else
    free_spaces[#free_spaces+1] = create_segment(id, begin, n)
  end
  begin = begin + n
  ::continue::
end

--[[
for _, file in ipairs(files) do
  print(file.id, file.begin, file.size)
end
print(" --- ")
for _, free_space in ipairs(free_spaces) do
  print(free_space.id, free_space.begin, free_space.size)
end
]]

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
end


-- p.printArray(unpacked)

local function move(file_i, space_i)
  local file = files[file_i]
  local space = free_spaces[space_i]

  for i = 0, file.size - 1 do
    unpacked[file.begin + i] = "."
    unpacked[space.begin + i] = file.id
  end
  if file.size == space.size then
    -- table.remove(free_spaces, space_i)
    space.begin = space.begin + file.size
    space.size = 0
  else
    space.begin = space.begin + file.size
    space.size = space.size - file.size
  end
end


for i = #files, 1, -1 do
  for j = 1, #free_spaces do
    -- print("i: ", i, ", j: ", j, #files, #free_spaces)
    if files[i].begin <= free_spaces[j].begin then
      break
    end

    if files[i].size <= free_spaces[j].size then
      move(i, j)
      break
    end
  end
end

local check_sum = 0
for i, id2 in ipairs(unpacked) do
  if id2 == "." then
    goto continue3
  end
  check_sum = check_sum + (i - 1) * tonumber(id2)
  ::continue3::
end

print("the sum is: ", check_sum)

