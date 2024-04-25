local luasnip = require('luasnip')
local s = luasnip.s
local f = luasnip.f

return {
  s("ft", f(function ()
    local branch = io.popen("git branch --show-current 2> /dev/null")
    if branch == nil then
      return "Feature: "
    end

    local name = branch:read()
    branch:close()
    if name == nil then
      return "Feature NONAME:"
    end

    local n = string.match(name, "feature/(%d+)")
    if n == nil then
      return "Feature:"
    end
    return string.format("Feature #%s: ", n)
  end)),
  s("fx", f(function ()
    local branch = io.popen("git branch --show-current 2> /dev/null")
    if branch == nil then
      return "Fix: "
    end

    local name = branch:read()
    branch:close()
    if name == nil then
      return "Fix NONAME:"
    end

    local n = string.match(name, "fix/(%d+)")
    if n == nil then
      return "Fix:"
    end
    return string.format("Fix #%s: ", n)
  end)
  ),
  s("bf", f(function ()
    local branch = io.popen("git branch --show-current 2> /dev/null")
    if branch == nil then
      return "Bugfix: "
    end

    local name = branch:read()
    branch:close()
    if name == nil then
      return "Bugfix NONAME:"
    end

    local n = string.match(name, "fix/(%d+)")
    if n == nil then
      return "Bugfix:"
    end
    return string.format("Bugfix #%s: ", n)
  end)
  )
}
