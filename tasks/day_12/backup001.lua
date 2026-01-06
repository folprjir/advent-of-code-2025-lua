print("This is day 12 task 1")

local path = "./data/test01.txt"

local m = {}

for line in io.lines(path) do
  local row = {}
  for char in line:gmatch(".") do
    row[#row+1] = { type = char, visited = false }
  end
  m[#m+1] = row
end

local steps = {{-1, 0}, {1, 0}, {0, -1}, {0, 1}}

local rows = #m
local cols = #m[1]

local function compute_price(type, first_row, first_col)

  local cells_cnt = 0
  local fences_cnt = 0

  local function inner(row, col)
    if row > 0 and row <= rows and
       col > 0 and col <= cols and
       not m[row][col].visited then

       for s in ipairs(steps) do
         local new_row = row + s[1]
         local new_col = row + s[2]
         if new_row == 0 or new_row > rows or
            new_col == 0 or new_col > cols or
            not m[new_row][new_col].type ~= type then

            fences_cnt = fences_cnt + 1
          else
            cells_cnt = cells_cnt + 1
            m[new_row][new_col].visited = true
            inner(new_row, new_col)
          end
       end


    end
  end

  inner(first_row, first_col)
  return cells_cnt * fences_cnt
end

for row_i, row in ipairs(m) do
  for col_i, cell in ipairs(row) do
    if not cell.visited then
      compute_price(cell.type, row_i, col_i)
    end
  end
end
