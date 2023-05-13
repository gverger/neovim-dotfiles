local luasnip = require('luasnip')
local c = luasnip.c
local s = luasnip.s
local t = luasnip.t
local i = luasnip.i

return {
  s("slot", fmt([[- [{}] {}{} - {}{} : {}]],
  {
    c(1, {t "CorNet", t " SIME ", t "Deport", t " FF4  ", t " Autre"}),
    i(2),
    c(3, {t "h00", t "h15", t "h30", t "h45"}),
    i(4),
    c(5, {t "h00", t "h15", t "h30", t "h45"}),
    i(6),
  })),
}, nil
