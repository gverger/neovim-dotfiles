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
  end)
  )
}
