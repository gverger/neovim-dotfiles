local luasnip = require('luasnip')
local c = luasnip.c
local s = luasnip.s
local t = luasnip.t
local f = luasnip.f
local i = luasnip.i

local days = { "Dimanche", "Lundi", "Mardi", "Mercredi", "Jeudi", "Vendredi", "Samedi" }
local months = { "Janvier", "Février", "Mars", "Avril", "Mai", "Juin", "Juillet", "Août", "Septembre", "Octobre", "Novembre", "Décembre" }

local function current_line()
  local current = vim.api.nvim_win_get_cursor(0)[1]
  local lines = vim.api.nvim_buf_get_lines(0, current-1, current, false)
  return lines[1] or ""
end

math.randomseed(os.time())

return {
  s("uuid", f(function ()
    local template ='xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
    return string.gsub(template, '[xy]', function (char)
      local v = (char == 'x') and math.random(0, 0xf) or math.random(8, 0xb)
      return string.format('%x', v)
    end)
  end)),
  s("=", f(function ()
    local operation = loadstring("return " .. current_line())
    if operation then
      local ok, result = pcall(function()
        return tostring(operation())
      end)
      if ok then
        return "= " .. result
      else
        error(result)
      end
    end
    return "="
  end
  )),
  s({ trig = "%(=(.+)%)", regTrig = true }, f(function(_, snip)
    local operation = loadstring("return " .. snip.captures[1])
    if operation then
      local ok, result = pcall(function()
        return tostring(operation())
      end)
      if ok then
        return result
      end
    end
    return "(=" .. snip.captures[1] .. ")"
  end, {})
  ),
  s("isonow", {f(function ()
    return os.date("!%Y-%m-%dT%TZ")
  end)}),
  s("hier",
  f(function ()
    local date = os.date("*t", os.time() -24*60*60)
    return days[date.wday] .. " " .. date.day .. " " .. months[date.month]
  end)),
  s("auj",
  f(function ()
    local date = os.date("*t")
    return days[date.wday] .. " " .. date.day .. " " .. months[date.month]
  end)),
  s("now", {
    c(1, {
      f(function ()
        return os.date "%d/%m"
      end),
      f(function ()
        return os.date "%d/%m/%y"
      end),
      f(function ()
        return os.date "%d/%m/%y - %H:%M"
      end),
      f(function ()
        local date = os.date("*t")
        return days[date.wday] .. " " .. date.day .. " " .. months[date.month]
      end),
      f(function ()
        return os.date("%A %d %B")
      end),
    })
  })
}
