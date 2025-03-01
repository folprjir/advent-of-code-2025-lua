package.path = package.path .. ";../../../utils/utils.lua"
require "utils"

local input = LoadFile("../data/in01.txt")
local m = 109
local u = 117
local l = 108
local open = 40 -- (
local close = 41 -- )
local comma = 44 -- ,

local i = 1
local sum = 0
local byte = nil

local d1, d2, d3
local digits
local n1, n2


local function next()
  byte = string.byte(input, i)
  i = i + 1
  return byte
end


local function digit()
  -- 48 -> 0, 57 -> 9
  if (byte > 47) and (byte < 58) then
    if     digits == 3 then d1 = byte - 48
    elseif digits == 2 then d2 = byte - 48
    elseif digits == 1 then d3 = byte - 48
    else return false
    end
  else
    return false
  end
  return true
end


local function getValue()
  return math.floor((d1 * 100 + d2 * 10 + d3) / 10 ^ digits)
end

::state1::
if next() == m then goto state2 end goto error

::state2::
if next() == u then goto state3 end goto error

::state3::
if next() == l then goto state4 end goto error

::state4::
if next() == open then goto state5 end goto error

::state5::
digits = 3
d1, d2, d3 = 0, 0, 0
next()
if digit() then goto state6 end goto error

::state6::
digits = digits - 1
if (next() == comma) then
  n1 = getValue()
  goto state7
elseif (digits <= 0) or (not digit()) then
  goto error
end
goto state6

::state7::
digits = 3
d1, d2, d3 = 0, 0, 0
next()
if digit() then goto state8 end goto error

::state8::
digits = digits - 1
if (next() == close) then
  n2 = getValue()
  goto state9
elseif (digits <= 0) or (not digit()) then
  goto error
end
goto state8

::state9::
sum = sum + n1 * n2
if next() == m then
  goto state2
else
  goto state1
end

::error::
if not byte then
  goto finish
elseif byte == m then
  goto state2
else
  goto state1
end

::finish::
print(sum)
