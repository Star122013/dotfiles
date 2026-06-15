-- plugins/init.lua — loads plugin modules with lazy strategies
--
-- Timing:
--   1. themes       — immediate (colors must be set before UI renders)
--   2. core         — immediate (mini.nvim, telescope, treesitter)
--   3. lsp + tools  — on first real file open (BufReadPost → vim.schedule)

require("plugins.themes")
require("plugins.core")

vim.api.nvim_create_autocmd("BufReadPost", {
  once = true,
  callback = function()
    vim.schedule(function()
      require("plugins.lsp")
      require("plugins.tools")
    end)
  end,
})
