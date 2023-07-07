local luasnip = require('luasnip')
local s = luasnip.s
local i = luasnip.i

return {
    s("getset",
        fmt([[public {} {} {{ get; set; }}]], { i(1, "string"), i(2, "variable") })),

    s("namespc",
        fmt([[namespace {};]], { f(function()
            local relative_path = vim.fn.expand('%:h:.')
            return relative_path:gsub('/', '.')
        end) })),

    s('cls',
        fmt([[
        class {}
        {{
            {}
        }}]], { f(function()
            return vim.fn.expand('%:t'):gsub(".cs$", '')
        end), i(0) })),
}
