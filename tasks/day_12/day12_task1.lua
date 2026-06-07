print("This is day 12 task 1")

local path = "./data/input.txt"

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


local function is_out_of_bounce(row, col)
  return row == 0 or row > rows or
         col == 0 or col > cols
end


local function compute_price(type, first_row, first_col)
  local cells_cnt = 1
  local fences_cnt = 0
  m[first_row][first_col].visited = true
  local function inner(row, col)
     for _, s in ipairs(steps) do
       local new_row = row + s[1]
       local new_col = col + s[2]
       if is_out_of_bounce(new_row, new_col) or
          m[new_row][new_col].type ~= type then
          fences_cnt = fences_cnt + 1
        else
          if not m[new_row][new_col].visited then
            m[new_row][new_col].visited = true
            cells_cnt = cells_cnt + 1
            inner(new_row, new_col)
          end
        end
     end
  end
  inner(first_row, first_col)
  return cells_cnt * fences_cnt
end


local sum = 0
for row_i, row in ipairs(m) do
  for col_i, cell in ipairs(row) do
    if not cell.visited then
      sum = sum + compute_price(cell.type, row_i, col_i)
    end
  end
end

print(sum)
