local M = {}


function M.printArrayDet(array)
  io.write("Printing an array\n")
  for i, v in pairs(array) do
    io.write("Index: ", i, " Value ", v, "\n")
  end
  print("\nArray printed\n")
end


function M.printArray(arr)
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


function M.printTable(t)
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


function M.printMatrix(m)
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


return M
