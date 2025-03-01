package.path = package.path .. ";../../../utils/utils.lua"
require "utils"

local lines = GetLinesFromFile("../data/in01.txt")

local function isSafe(seq, ignore)

  if #seq == 0 then return false end
  if #seq <= 2 then return true end

  local type = {
    ASC = 1,
    DESC = 2,
    UNKNOWN = 3,
  }

  local maxDelta = 3
  local minDelta = 1
  local prev = seq[1]
  local i1 = 2
  if ignore == 1 then
    prev = seq[2]
    i1 = 3
  end

  local dir = type.UNKNOWN

  for i = i1, #seq do
    if not (i == ignore) then
      local delta = math.abs(prev - seq[i])
      if delta > maxDelta then
	return false
      end
      if delta < minDelta then
	return false
      end
      if prev - seq[i] > 0 then
	if dir == type.DESC then
	  return false
	end
	dir = type.ASC
      end
      if prev - seq[i] < 0 then
	if dir == type.ASC then
	  return false
	end
	dir = type.DESC
      end
      prev = seq[i]
    end
  end

  return true
end

-- PrintArray(lines)

local numOfSafe = 0
for _, line in ipairs(lines) do

  local safe = false
  local nums = ExtractNumbers(line)

  if not safe then
    for i = 0, #nums do
      -- local numsStr = table.concat(nums, ", ")
      -- print("nums:", numsStr, ", i:", i, ", safe:", isSafe(nums, i))
      if isSafe(nums, i) then
	safe = true
	break
      end
    end
  end

  if safe then
    numOfSafe = numOfSafe + 1
  end
end

print(numOfSafe)


