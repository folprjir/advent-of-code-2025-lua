local Set = {}
Set.__index = Set

function Set:new()
  return setmetatable({}, Set)
end

function Set:insert(val)
  self[val] = true
end

function Set:has(val)
  return self[val] or false
end

return Set
