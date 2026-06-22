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

require("plugins.ui")
require("plugins.core")

require("plugins.lsp")
require("plugins.tools")

require("plugins.completion")
