local highlight = {
    "Red",
    "Yellow",
    "Blue",
    "Orange",
    "Green",
    "Violet",
    "Cyan",
}

local hooks = require('ibl.hooks')

hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
    vim.api.nvim_set_hl(0, "Red", { fg = "#E06C75" })
    vim.api.nvim_set_hl(0, "Yellow", { fg = "#E5C07B" })
    vim.api.nvim_set_hl(0, "Blue", { fg = "#61AFEF" })
    vim.api.nvim_set_hl(0, "Orange", { fg = "#D19A66" })
    vim.api.nvim_set_hl(0, "Green", { fg = "#98C379" })
    vim.api.nvim_set_hl(0, "Violet", { fg = "#C678DD" })
    vim.api.nvim_set_hl(0, "Cyan", { fg = "#56B6C2" })
end)

require('ibl').setup({ indent = { highlight = highlight, } })
