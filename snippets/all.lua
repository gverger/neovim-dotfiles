local luasnip = require('luasnip')
local c = luasnip.c
local s = luasnip.s
local t = luasnip.t
local f = luasnip.f

local days = { "Dimanche", "Lundi", "Mardi", "Mercredi", "Jeudi", "Vendredi", "Samedi" }
local months = { "Janvier", "Février", "Mars", "Avril", "Mai", "Juin", "Juillet", "Août", "Septembre", "Octobre",
  "Novembre", "Décembre" }

local function current_line()
  local current = vim.api.nvim_win_get_cursor(0)[1]
  local lines = vim.api.nvim_buf_get_lines(0, current - 1, current, false)
  return lines[1] or ""
end

local function uuid_fill(template)
  return string.gsub(template, '[xy]', function(char)
    local v = (char == 'x') and math.random(0, 0xf) or math.random(8, 0xb)
    return string.format('%x', v)
  end)
end

local function all_days_en()
  local alldays = {}
  for i = -31, 31, 1 do
    local date = os.date("%A %d %B", os.time() + 24*60*60 * i)
    table.insert(alldays, t(date))
  end
  return alldays
end

local function all_days_fr()
  local alldays = {}
  for i = -31, 31, 1 do
    local date = os.date("*t", os.time() + 24*60*60 * i)
    table.insert(alldays, t( days[date.wday] .. " " .. date.day .. " " .. months[date.month]))
  end
  return alldays
end

math.randomseed(os.time())

return {
  s("uuid", {
    c(1, {
      f(function()
        return uuid_fill("xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx")
      end),
      f(function()
        return uuid_fill("xxxxxxxxxxxx4xxxyxxxxxxxxxxxxxxx")
      end),
    })
  }),
  s("mrid", f(function()
    return uuid_fill("_xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx")
  end)),
  s("=", f(function()
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
  s("isonow", { f(function()
    return os.date("!%Y-%m-%dT%TZ")
  end) }),
  s("demain",
    f(function()
      local date = os.date("*t", os.time() + 24 * 60 * 60)
      return days[date.wday] .. " " .. date.day .. " " .. months[date.month]
    end)),
  s("hier",
    f(function()
      local date = os.date("*t", os.time() - 24 * 60 * 60)
      return days[date.wday] .. " " .. date.day .. " " .. months[date.month]
    end)),
  s("auj",
    f(function()
      local date = os.date("*t")
      return days[date.wday] .. " " .. date.day .. " " .. months[date.month]
    end)),
  s("today",
    f(function()
      return os.date("%A %d %B")
    end)),
  s("day", {
    c(1, all_days_en()),
  }),
  s("jour", {
    c(1, all_days_fr()),
  }),
  s("now", {
    c(1, {
      f(function()
        return os.date "%d/%m"
      end),
      f(function()
        return os.date "%d/%m/%y"
      end),
      f(function()
        return os.date "%d/%m/%y - %H:%M"
      end),
      f(function()
        local date = os.date("*t")
        return days[date.wday] .. " " .. date.day .. " " .. months[date.month]
      end),
      f(function()
        return os.date("%A %d %B")
      end),
    })
  }),
  s("gbranch", f(function()
    local handle = io.popen("git branch --show-current")
    local result = handle:read("*a")
    handle:close()
    return result:gsub('[\n\r]', '')
  end))

}
