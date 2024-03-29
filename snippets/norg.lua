local luasnip = require('luasnip')
local c = luasnip.c
local s = luasnip.s
local t = luasnip.t
local f = luasnip.f
local i = luasnip.i


return {
  s("file", fmt('{{:{}:}}[{}]', { i(1, "file-name"), i(2, "Linking to...") })),
  s("tt", fmt([[
  ** {}
  - Projet : {}
  - Activité : {}
  - Temps passé : {}h{}

  ]], { i(1, "Tâche"),
    c(2, { t "CorNet", t "CorNet SWE", t "SHeRPa", t "SIME", t "Libra", t "Autre", t "Perso" }),
    c(3, { t "Dev", t "Design", t "Autre", }),
    i(4), i(5) })),
}
