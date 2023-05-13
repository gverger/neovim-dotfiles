local luasnip = require('luasnip')
local c = luasnip.c
local s = luasnip.s
local t = luasnip.t
local f = luasnip.f
local i = luasnip.i


return { 
  s("file", fmt('{{:{}:}}[{}]', {i(1, "file-name"), i(2, "Linking to...")})),
}
