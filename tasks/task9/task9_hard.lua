package.path = package.path .. ";../../utils/?.lua;../../structures/?.lua"

local p = require "print_utils"
local f = require "file_utils"

local test1 = "2222222"
local test2 = "2333133121414131402"

local packed = f.loadFile("./data/input.txt")
packed = test2

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

p.printArray(unpacked)


local files = {}
local free_spaces = {}

local free_space = false
local head = 1
local id = 0
local segment_start = 1
local segment_end = 0


local function create_segment()
  local res = {
    id = id,
    segment_start = segment_start,
    segment_end = segment_end
  }
  segment_start = segment_end
  return res
end


for i, val in ipairs(unpacked) do

  -- print("parsing", val, ", start: ", segment_start, ", end: ", segment_end, ", id: ", id, ", val: ", val)

  if val == "." and segment_start == segment_end then
    segment_end = segment_end + 1
    segment_start = segment_start + 1
    goto continue
  end

  if val == "." then
    files[#files + 1] = create_segment()
    id = -1
    segment_end = segment_end + 1
    segment_start = segment_start + 1
    goto continue
  end

  if id == -1 then
    id = val -- at this point val is a number
    segment_end = segment_end + 1
    segment_start = segment_start + 1

    if i < #unpacked and unpacked[i + 1] == "." then
      files[#files + 1] = create_segment()
      id = -1
    end

    goto continue
  end

  if id ~= val then
    files[#files + 1] = create_segment()
    id = val
    segment_end = segment_end + 1
    segment_start = segment_start + 1
    goto continue
  end

  segment_end = segment_end + 1

  ::continue::
end

if segment_start ~= segment_end then
    files[#files + 1] = create_segment()
end

for i, seg in ipairs(files) do
  print("i: ", i, ", id: ", seg.id,
    ", start: ", seg.segment_start, ", end: ", seg.segment_end)
end




