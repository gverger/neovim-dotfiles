local luasnip = require('luasnip')
local c = luasnip.c
local s = luasnip.s
local t = luasnip.t
local f = luasnip.f
local i = luasnip.i

return {
  s("task", fmt('- [ ] {}', { i(0) })),
  s("image", fmt([[
  #figure(
    image("./images/{}", width: 80%),
    caption: [{}]
  )
  {}
  ]], {
    i(1), i(2), i(0),
    -- c(1, all_days_en()), i(2), i(0),
  })),
}
