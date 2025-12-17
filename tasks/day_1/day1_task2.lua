local function extractNumbers(str)
  str = str .. ";"
  local result = {}
  local startIndex = -1
  for i = 1, #str do
    local byte = string.byte(str, i)
    local isNumber = byte >= 48 and byte <= 57 -- 48 -> 0, 57 -> 9
    if isNumber and startIndex == -1 then
      startIndex = i
    elseif not isNumber then
      if startIndex > 0 then
	result[#result + 1] = string.sub(str, startIndex, i - 1)
      end
      startIndex = -1
    end
  end
  return result
end


local function stringsToNumbers(strings)
  local result = {}
  for _, strNumber in ipairs(strings) do
    local number = tonumber(strNumber)
    if (number ~= nil) then
      result[#result + 1] = number
    end
  end
  return result
end


local function getLinesFromFile(path)
  local result = {}
  for line in io.lines(path) do
    result[#result + 1] = line
  end
  return result
end


local lines = getLinesFromFile("./data/in01.txt")
local column1 = {}
local column2 = {}

for i, line in ipairs(lines) do
  local nums = extractNumbers(line)
  column1[#column1+1] = nums[1]
  column2[#column2+1] = nums[2]
end

local leftList = stringsToNumbers(column1)
local rightList = stringsToNumbers(column2)

table.sort(leftList)
table.sort(rightList)

local currentNum = rightList[1]
local count = 0
local numberToCount = {}
for _, nextNumber in ipairs(rightList) do
  if currentNum == nextNumber then
    count = count + 1
  else
    numberToCount[currentNum] = count
    count = 1
    currentNum = nextNumber
  end
end
numberToCount[currentNum] = count
local sum = 0
for _, number in ipairs(leftList) do
  local cnt = numberToCount[number]
  if cnt ~= nil then
    sum = sum + cnt * number
  end
end
print(sum)
