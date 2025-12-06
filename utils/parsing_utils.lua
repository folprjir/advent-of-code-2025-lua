local M = {}


function M.createMatrix(lines)
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


-- args: line: string
-- return arr<int>
function M.extractNumbersFromString(str)
  local res = {}
  local index = 1
  local byte = 0

  local function next()
    if index > #str then
      byte = 0
      return byte
    end
    byte = string.byte(str, index)
    index = index + 1
    return byte
  end

  local val -- value for the whole part
  local exp
  local dot = 46 -- .

  local fVal = 0 -- value for the decimal part
  local div = 1

  ::state1::
  exp = 1
  val = 0
  if next() == 0 then
    goto finish
  elseif IsDigit(byte) then
    val = byte - 48
    goto state2
  end
  goto state1

  ::state2::
  if next() == dot then
    -- print("c1")
    goto state3
  elseif IsDigit(byte) then
    exp = exp * 10
    val = val * 10 + (byte - 48)
    goto state2
  end
  goto state5

  ::state3::
  div = 10
  fVal = 0
  if IsDigit(next()) then
    fVal = fVal * 10 + (byte - 48)
    goto state4
  end
  goto state5

  ::state4::
  if IsDigit(next()) then
    fVal = fVal * 10 + (byte - 48)
    div = div * 10
    goto state4
  end
  goto state5

  ::state5::
  table.insert(res, val + fVal / div)
  goto state1

  ::finish::
  return res
end


return M
