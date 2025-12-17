package.path = package.path .. ";../../../utils/utils.lua"
require "utils"

local input = LoadFile("../data/in01.txt")

local m = 109
local u = 117
local l = 108
local open = 40 -- (
local close = 41 -- )
local comma = 44 -- ,

local d = 100
local o = 111
local n = 110
local apos = 39
local t = 116

local i = 1
local sum = 0
local enabled = true
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


::state1:: -- print("s1")
if next() == m then
  goto state2
elseif byte == d then
  goto state6
end
goto error

::state2:: -- print("s2")
if next() ~= u then goto error end
if next() ~= l then goto error end
if next() ~= open then goto error end
digits = 3
d1, d2, d3 = 0, 0, 0
next()
if digit() then goto state3 end goto error
goto state3

::state3:: -- print("s3")
digits = digits - 1
if (next() == comma) then
  n1 = getValue()
  digits = 3
  d1, d2, d3 = 0, 0, 0
  next()
  if digit() then goto state4 end goto error
elseif (digits <= 0) or (not digit()) then
  goto error
end
goto state3

::state4:: -- print("s4")
digits = digits - 1
if (next() == close) then
  n2 = getValue()
  goto state5
elseif (digits <= 0) or (not digit()) then
  goto error
end
goto state4

::state5:: -- print("s5")
if enabled then
  sum = sum + n1 * n2
end
next()
goto error

::state6:: -- print("s6")
if next() == o then goto state7 end goto error

::state7:: -- print("7")
if next() == open then
  goto state8
elseif byte == n then
  goto state10
end
goto error

::state8:: -- print("s8")
if next() == close then goto state9 end goto error

::state9:: -- print("s9")
enabled = true
next()
goto error

::state10:: -- print("s10")
if next() ~= apos then goto error end
if next() ~= t then goto error end
if next() ~= open then goto error end
if next() ~= close then goto error end
goto state11

::state11:: -- print("s11")
enabled = false
next()
goto error

::error::  -- print("err")
if not byte then
  goto finish
elseif byte == m then
  goto state2
elseif byte == d then
  goto state6
else
  goto state1
end

::finish::
print(sum)
