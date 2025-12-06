local M = {}


function M.getLinesFromFile(path)
  local result = {}
  for line in io.lines(path) do
    result[#result + 1] = line
  end
  return result
end


function M.loadFile(path)
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


return M

