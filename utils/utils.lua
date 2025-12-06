

function PrintArrayDet(array)
  io.write("Printing an array\n")
  for i, v in pairs(array) do
    io.write("Index: ", i, " Value ", v, "\n")
  end
  print("\nArray printed\n")
end


function PrintArray(arr)
  io.write("[")
  for i = 1, #arr do
    if arr[i] == nil then
      io.write("nil")
    else
      io.write(arr[i])
    end
    if i ~= #arr then
      io.write(", ")
    end
  end
  io.write("]\n")
end


function PrintTable(t)
  io.write("{ ")
  for _, v in pairs(t) do
    if v == true then
      io.write("T")
    elseif v == false then
      io.write("F")
    elseif v == nil then
      io.write("N")
    elseif type(v) == "table" then
      io.write("#")
    else
      io.write(v)
    end
    io.write(" ")
  end
  io.write("}\n")
end


function ExtractNumbers(str)
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


function StringsToNumbers(strings)
  local result = {}
  for _, strNumber in ipairs(strings) do
    local number = tonumber(strNumber)
    if (number ~= nil) then
      result[#result + 1] = number
    end
  end
  return result
end


function GetLinesFromFile(path)
  --local file = io.open(path, "rb")
  -- if not file then
  --     return result
  -- end
  local result = {}
  for line in io.lines(path) do
    result[#result + 1] = line
  end
  return result
end


function LoadFile(path)
  local file = io.open(path, "r")
  local content = nil
  if file then
    content = file:read("*a")
    file:close()
  else
    print("Failed to open:", path)
  end
  return content
end


function IsDigit(byte)
  -- 48 -> 0, 57 -> 9 
  return (byte > 47) and (byte < 58)
end


function PrintMatrix(m)
  for row = 1, #m do
    for col = 1, #m[row] do
      if m[row] == nil then
	print("row:", row, ", is nil")
      elseif m[row][col] == nil then
	print("row:", row, ", col:", col, ", is nil")
      else
	local cell = m[row][col]
	if type(cell) == "table" then
	  io.write("@")
	else
	  io.write(m[row][col])
	end
      end
    end
    print()
  end
end

function CreateMatrix(lines)
  local res = {}
  local longest = 0
  local shortest = 2^53 - 1
  for row, line in ipairs(lines) do
    res[row] = {}
    for col = 1, #line do
      res[row][col] = string.sub(line, col, col)
    end
    if #line > longest then
      longest = #line
    end
    if #line < shortest then
      shortest = #line
    end
  end
  return res, shortest, longest
end

