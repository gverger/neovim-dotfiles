local luasnip = require('luasnip')
local s = luasnip.s
local f = luasnip.f
local i = luasnip.i

local function branchName()
  local branch = io.popen("git branch --show-current 2> /dev/null")
  if branch == nil then
    return ""
  end

  local name = branch:read()
  branch:close()
  if name == nil then
    return "NONAME"
  end

  return name
end

local function featureId()
  local n = string.match(branchName(), "feature/(%d+)")
  if n == nil then
    return ""
  end
  return n
end

local function fixId()
  local n = string.match(branchName(), "fix/(%d+)")
  if n == nil then
    return ""
  end
  return n
end

return {
  s("ft", f(function()
    local name = featureId()
    if name == "" then
      return "Feature: "
    end

    return string.format("Feature #%s: ", name)
  end)),

  s("fx", f(function()
    local name = fixId()
    if name == "" then
      return "Fix: "
    end
    return string.format("Fix #%s: ", name)
  end)
  ),
  s("bf", f(function()
    local name = fixId()
    if name == "" then
      return "Bugfix: "
    end
    return string.format("Bugfix #%s: ", name)
  end)
  ),

  s("feat", fmt([[feat({}): {}{}]], { i(1, "scope"), i(0, "title"), f(function()
    local name = featureId()
    if name == "" then
      return ""
    end

    return " #" .. name
  end) }
  )),
  s("fix", fmt([[fix({}): {}{}]], { i(1, "scope"), i(0, "title"), f(function()
    local name = fixId()
    if name == "" then
      return ""
    end

    return " #" .. name
  end) }
  )),

}
