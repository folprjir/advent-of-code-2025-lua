package.path = package.path .. ";../../../utils/utils.lua"

require "utils"

local lines = GetLinesFromFile("../data/in01.txt")

local function isSafe(seq)

  local type = {
    ASC = 1,
    DESC = 2,
    UNKNOWN = 3,
  }

  local maxDelta = 3
  local minDelta = 1
  local prev = seq[1]
  local dir = type.UNKNOWN
  for i = 2, #seq do
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
  return true
end

local numberOfSafe = 0
for _, line in ipairs(lines) do
  if isSafe(ExtractNumbers(line)) then
    numberOfSafe = numberOfSafe + 1
  end
end

print(numberOfSafe)



