package.path = package.path .. ";../../../utils/utils.lua"

require "utils"

local linesLoaded = GetLinesFromFile("./data/in01.txt")

local function reverseMatrixInPlace(m)

local function reverseArray(arr)
    local n = #arr
    for i = 1, math.floor(n / 2) do
      local tmp = arr[i]
      arr[i] = arr[n - i + 1]
      arr[n - i + 1] = tmp
    end
  end

  for row = 1, #m do
    reverseArray(m[row])
  end
end

local function reverseMatrix(m)

  local rows = #m

  local res = {}
  for row = 1, rows do
    local cols = #m[row]
    res[row] = {}
    for col = 1, cols do
      -- print("row:", row, ", col:", col, "cols - col + 1:", cols - col + 1)
      res[row][col] = m[row][cols - col + 1]
    end
  end
  return res
end


local function transposeMatrix(m)
  local t = {}
  local rows, cols = #m, #m[1]

  for col = 1, cols do
    t[col] = {}
    for row = 1, rows do
      t[col][row] = m[row][col]
    end
  end

  return t
end

local function getDiagonal(m, row, col)
  local res = {}
  local i = 1
  local cols = #m[1]

  -- print("diagonal for row:", row, ", col:", col)
  -- print("diagonal for rows:", #m, ", cols:", cols)
  while (row > 0) and (col <= cols) do
    res[i] = m[row][col]
    if res[i] == nil then
      print("nil produced row:", row, ", col:", col, "-------------------------------")
    end
    row = row - 1
    col = col + 1
    i = i + 1
  end

  -- print("diagonal length: ", #res)

  return res
end

local function diagonal1(m)
  local d = {}

  print("matrix has rows: ", #m)

  for row = 1, #m do
    d[row] = getDiagonal(m, row, 1)
    -- PrintArray(d[row])
  end

  local cols = #m[1]
  for col = 2, cols do
    d[col + #m - 1] = getDiagonal(m, #m, col)
    -- PrintArray(d[col + #m - 1])
    if d[col + #m - 1] == nil then
      print("it is nil -------------------------------")
    end
  end

  return d
end


local function countXmasRow(row)
  local i = 0
  local res = 0
  local byte = 0

  local function next()
    i = i + 1
    if i > #row then
      return nil
    end
    byte = row[i]
    return byte
  end

  ::state1::
  if not next() then return res end;
   -- print("s1: ", row[i])
  if byte == "X" then goto state2 end goto error

  ::state2::
  if not next() then return res end;
   -- print("s2: ", row[i])
  if byte == "M" then goto state3 end goto error

  ::state3::
  if not next() then return res end;
   -- print("s3: ", row[i])
  if byte == "A" then goto state4 end goto error

  ::state4::
  if not next() then return res end;
   -- print("s4: ", row[i])
  if byte == "S" then goto state5 end goto error

  ::state5::
   -- print("state 5")
  res = res + 1
  goto error

  ::error::
  if row[i] == "X" then
    goto state2
  end
  goto state1

end

local function countXmas(m)
  local res = 0
  for row = 1, #m do
    res = res + countXmasRow(m[row])
  end
  return res
end

local sum = 0


local m1 = CreateMatrix(linesLoaded)
PrintMatrix(m1)
sum = sum + countXmas(m1)
print("sum 1:", sum)


local m2 = reverseMatrix(m1)
-- printMatrix(m2)
sum = sum + countXmas(m2)
print("sum 2:", sum)

local m3 = transposeMatrix(m1)
-- printMatrix(m3)
sum = sum + countXmas(m3)
print("sum 3:", sum)

local m4 = reverseMatrix(m3)
-- printMatrix(m4)
sum = sum + countXmas(m4)
print("sum 4:", sum)



local m5 = diagonal1(m1)
PrintMatrix(m5)
sum = sum + countXmas(m5)
print("sum 5:", sum)

local m6 = reverseMatrix(m5)
-- printMatrix(m6)
sum = sum + countXmas(m6)
print("sum 6:", sum)

local m7 = diagonal1(m2)
-- printMatrix(m7)
sum = sum + countXmas(m7)
print("sum 7:", sum)

local m8 = reverseMatrix(m7)
-- printMatrix(m8)
sum = sum + countXmas(m8)
print("sum 8:", sum)
