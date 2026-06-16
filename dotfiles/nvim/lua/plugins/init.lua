-- plugins/init.lua — loads plugin modules with lazy strategies
--
-- Loading phases:
--   0. themes       — immediate (colorscheme must be set before UI renders)
--   1. ui + core    — on UIEnter (statusline, tabline, notifications, editor features)
--   2. lsp + tools  — on first BufReadPost (LSP, formatting, linting, git, code actions)
--   3. completion   — on first InsertEnter (blink.cmp)
--
-- Plugins within each module may further defer using autocmds or keymaps:
--   typst-preview  → FileType typst
--   neogit         → <Leader>gg keymap (already lazy)
--   telescope      → UIEnter (before any telescope keymap can be triggered)

require("plugins.themes")

vim.api.nvim_create_autocmd("UIEnter", {
  once = true,
  callback = function()
    vim.schedule(function()
      require("plugins.ui")
      require("plugins.core")
    end)
  end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
  once = true,
  callback = function()
    vim.schedule(function()
      require("plugins.lsp")
      require("plugins.tools")
    end)
  end,
})

vim.api.nvim_create_autocmd("InsertEnter", {
  once = true,
  callback = function()
    vim.schedule(function()
      require("plugins.completion")
    end)
  end,
})
