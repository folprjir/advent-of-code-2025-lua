print("This is day 11 task 2")

local path = "./data/input.txt"
local file = io.open(path, "r")

--@type string
local file_content = ""

if file then
  file_content = file:read("*a")
  file:close()
else
  assert(false, string.format("Failed to open file: %s", path))
end

print(file_content)

local first = {}


for num_str in file_content:gmatch("%S+") do
  first[#first + 1] = num_str
end


local function split_stone(stone)
  local left, right, right_no_zero_lead = {}, {}, {}
  local half = #stone / 2
  for i = 1, #stone do
    if i <= half then
      left[#left + 1] = stone:sub(i, i)
    else
      right[#right + 1] = stone:sub(i, i)
    end
  end

  local zero_lead = true
  for i = 1, #right do
    if i == #right or right[i] ~= "0" then zero_lead = false end
    if not zero_lead then
      right_no_zero_lead[#right_no_zero_lead + 1] = right[i]
    end
  end
  return { table.concat(left), table.concat(right_no_zero_lead) }
end

local function reverse_array(arr)
  local i, j = 1, #arr
  while i < j do
    arr[i], arr[j] = arr[j], arr[i]
    i = i + 1
    j = j - 1
  end
end

local function plus(a_str, b_str)
  local res = {}
  local a, b = {}, {}
  for s in a_str:gmatch(".") do a[#a + 1] = s end
  for s in b_str:gmatch(".") do b[#b + 1] = s end

  reverse_array(a)
  reverse_array(b)

  if #a < #b then
    local tmp = a
    a = b
    b = tmp
  end

  local carry = 0
  local an, bn = 0, 0
  for i = 1, #a do
    if i > #b then
      an = tonumber(a[i])
      bn = 0
    else
      an = tonumber(a[i])
      bn = tonumber(b[i])
    end
    local n = an + bn + carry
    carry = math.floor(n / 10)
    res[#res + 1] = tostring(n % 10)
  end

  if carry > 0 then
    res[#res + 1] = "1"
  end

  reverse_array(res)
  return table.concat(res)
end

local function mult_2024(stone)
  local n2 = plus(stone, stone)
  local n4 = plus(n2, n2)
  local n20 = n2 .. "0"
  local n24 = plus(n20, n4)
  local n2000 = n2 .. "000"
  return { plus(n2000, n24) }
end

local function blink_on_one_stone(stone)
  if stone == "0" then return { "1" } end
  if #stone % 2 == 0 then
    return split_stone(stone)
  end
  return mult_2024(stone)
end


local function print_arr(arr)
  io.write("[ ")
  for _, val in ipairs(arr) do
    io.write(val)
    io.write(" ")
  end
  print("]")
end

local memo = {}

local function memo_get(stone, step)
  local stone_memo = memo[stone]
  if stone_memo == nil then return nil end
  return stone_memo[step]
end

local function memo_add(stone, step, n)
  local stone_memo = memo[stone]
  if stone_memo == nil then
    memo[stone] = {}
  end
  memo[stone][step] = n
end


local function count_stones(stones, step)
  if step == 0 then
    return #stones
  end
  local sum = 0
  for _, stone in ipairs(stones) do
    local cnt = memo_get(stone, step)
    if cnt == nil then
      cnt = count_stones(blink_on_one_stone(stone), step - 1)
      memo_add(stone, step, cnt)
    end
      sum = sum + cnt
  end
  return sum
end

print(count_stones(first, 75))

