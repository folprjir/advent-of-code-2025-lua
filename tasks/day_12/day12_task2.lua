print("This is day 12 task 2")

local path = "./data/input.txt"

local m = {}

for line in io.lines(path) do
  local row = {}
  for char in line:gmatch(".") do
    row[#row+1] = { type = char, visited = false, component_id = -1 }
  end
  m[#m+1] = row
end


local steps = {{-1, 0}, {1, 0}, {0, -1}, {0, 1}}

local rows = #m
local cols = #m[1]


local function is_out_of_bounce(row, col)
  return row == 0 or row > rows or
         col == 0 or col > cols
end


local function is_part(id, row, col)
  if is_out_of_bounce(row, col) then
    return false
  end
  return m[row][col].component_id == id
end

local function x(row, col)
  if is_out_of_bounce(row, col) then
    return "#"
  end
  return m[row][col].type
end

local function is_corner(id, c_row, c_col, first_row, first_col, second_row, second_col)

  print(string.format("is_c>>> id: %d, c: (%d, %d), first: (%d, %d), second_row: (%d, %d)",
    id, c_row, c_col, first_row, first_col, second_row, second_col))

  local sum = 0
  -- print(string.format("first: %s", x(first_row, first_col)))
  if is_part(id, first_row, first_col) then
    sum = sum + 1
  end
  -- print(string.format("second: %s", x(second_row, second_col)))
  if is_part(id, second_row, second_col) then
    sum = sum + 1
  end
  -- print(string.format(">>> is_corner sum: %d", sum))


  local c_id = -42
  if not is_out_of_bounce(c_row, c_col) then
    c_id = m[c_row][c_col].component_id
  end
  print("id", id, "c_id", c_id)
  if not is_out_of_bounce(c_row, c_col) and m[c_row][c_col].component_id == id then
    print("sum1: ", sum)
    return sum == 0
  end
  print("sum2: ", sum)
  return sum ~= 1
end


local function corners(id, row, col)

  print(string.format("row: %d, col %d Exam", row, col))

  local sum = 0
  if is_corner(id,
    row - 1, col - 1,
    row    , col - 1,
    row - 1, col
  ) then
     print("c1 ----------------------------------------")
    sum = sum + 1
  end

  if is_corner(id,
    row - 1, col + 1,
    row    , col + 1,
    row - 1, col
  ) then
    print("c2 ----------------------------------------")
    sum = sum + 1
  end

  if is_corner(id,
    row + 1, col - 1,
    row    , col - 1,
    row + 1, col
  ) then
    print("c3 ----------------------------------------")
    sum = sum + 1
  end

  if is_corner(id,
    row + 1, col + 1,
    row    , col + 1,
    row + 1, col
  ) then
    print("c4 ----------------------------------------")
    sum = sum + 1
  end

  return sum
end



local component_id = 0

local function set_ids(type, first_row, first_col)

  component_id = component_id + 1
  m[first_row][first_col].component_id = component_id
  -- print(string.format("Changing id to %d, (%d, %d))", component_id, first_col, first_row))

  local function inner(row, col)
    for _, s in ipairs(steps) do
      local new_row = row + s[1]
      local new_col = col + s[2]

      -- print(string.format("The id is: %d", m[new_row][new_col].component_id))
      if not is_out_of_bounce(new_row, new_col) and m[new_row][new_col].type == type then
        if (m[new_row][new_col].component_id < 0) then
          m[new_row][new_col].component_id = component_id
          inner(new_row, new_col)
        end
      end
    end
  end

  inner(first_row, first_col)
end



for row_i, row in ipairs(m) do
  for col_i, cell in ipairs(row) do
    if (cell.component_id < 0) then
      set_ids(cell.type, row_i, col_i)
    end
  end
end

for row_i, row in ipairs(m) do
  for col_i, cell in ipairs(row) do
    io.write(m[row_i][col_i].component_id)
  end
  print()
end

local function compute_price(id, first_row, first_col)

  local cells_cnt = 1
  local corners_cnt = 0
  m[first_row][first_col].visited = true
  local function inner(row, col)

    for _, s in ipairs(steps) do
      local new_row = row + s[1]
      local new_col = col + s[2]

      if not is_out_of_bounce(new_row, new_col) and m[new_row][new_col].component_id == id then
        if not m[new_row][new_col].visited then
          m[new_row][new_col].visited = true
          cells_cnt = cells_cnt + 1
          inner(new_row, new_col)
        end
      end
    end

    corners_cnt = corners_cnt + corners(id, row, col)
  end

  inner(first_row, first_col)
  print(string.format("type: %s, cells: %d, corners: %d +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+", component_id, cells_cnt, corners_cnt))
  return cells_cnt * corners_cnt
end

local sum = 0

for row_i, row in ipairs(m) do
  for col_i, cell in ipairs(row) do
    if not cell.visited then
      sum = sum + compute_price(cell.component_id, row_i, col_i)
    end
  end
end

print(sum)
