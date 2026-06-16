---@diagnostic disable: unused-local, redundant-parameter
local gh = function(x) return "https://github.com/" .. x end

--=============================================================================
-- Inline diagnostics
--=============================================================================
vim.pack.add({ gh("rachartier/tiny-inline-diagnostic.nvim") })
require("tiny-inline-diagnostic").setup({
  preset = "compact",
  transparent_bg = true,
  signs = { enabled = false },
})

--=============================================================================
-- Code actions
--=============================================================================
vim.pack.add({ gh("rachartier/tiny-code-action.nvim") })
require("tiny-code-action").setup({
  picker = "telescope",
})

--=============================================================================
-- Git signs
--=============================================================================
vim.pack.add({ gh("lewis6991/gitsigns.nvim") })
require("gitsigns").setup({
  signs = {
    add          = { text = "▎" },
    change       = { text = "▎" },
    delete       = { text = "▁" },
    topdelete    = { text = "▔" },
    changedelete = { text = "▎" },
  },
  current_line_blame = false,
  preview_config = { border = vim.o.winborder },
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns
    local map = function(lhs, rhs, desc)
      vim.keymap.set("n", lhs, rhs, { buffer = bufnr, desc = desc })
    end
    map("]h", function() gs.nav_hunk("next") end, "Next Git hunk")
    map("[h", function() gs.nav_hunk("prev") end, "Previous Git hunk")
    map("<Leader>hp", gs.preview_hunk, "Preview hunk")
    map("<Leader>hs", gs.stage_hunk, "Stage hunk")
    map("<Leader>hr", gs.reset_hunk, "Reset hunk")
    map("<Leader>hb", function() gs.blame_line({ full = true }) end, "Blame line")
  end,
})

-- Neogit — lazy via keymap (require inside callback)
vim.pack.add({ gh("NeogitOrg/neogit") })
vim.keymap.set("n", "<Leader>gg", function() require("neogit").open() end, { desc = "Neogit" })

--=============================================================================
-- Typst preview — lazy via FileType
--=============================================================================
vim.pack.add({ gh("chomosuke/typst-preview.nvim") })
vim.api.nvim_create_autocmd("FileType", {
  pattern = "typst",
  once = true,
  callback = function()
    require("typst-preview").setup()
  end,
})
