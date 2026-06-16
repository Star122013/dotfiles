---@diagnostic disable: unused-local, redundant-parameter
local gh = function(x) return "https://github.com/" .. x end

--=============================================================================
-- Tabline — mini.tabline
--=============================================================================
vim.pack.add({ gh("nvim-mini/mini.tabline") })
require("mini.tabline").setup({
  show_icons = true,
})

--=============================================================================
-- Notifications — mini.notify
--=============================================================================
vim.pack.add({ gh("nvim-mini/mini.notify") })
require("mini.notify").setup()

--=============================================================================
-- Statusline — lualine
--=============================================================================
vim.pack.add({
  gh("nvim-lualine/lualine.nvim"),
})

require("lualine").setup({
  options = {
    theme = "auto",
    globalstatus = true,
    component_separators = { left = "|", right = "|" },
    section_separators = { left = "", right = "" },
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = { "branch" },
    lualine_c = {
      "filename",
      "diff",
      {
        "diagnostics",
        symbols = { error = "●", warn = "●", info = "●", hint = "●" },
      },
    },
    lualine_x = { "lsp_status", "filesize" },
    lualine_y = { "filetype", "progress" },
    lualine_z = { "location" },
  },
})
