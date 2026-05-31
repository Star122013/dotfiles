vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 2
vim.opt.scrolloff = 1000
vim.opt.autoread = true
vim.o.showtabline = 2
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.schedule(function() vim.opt.clipboard = "unnamedplus" end)
vim.opt.undofile = true
vim.opt.fillchars:append({ eob = " " })
vim.opt.sessionoptions = "curdir,folds,globals,help,tabpages,terminal,winsize"
vim.o.cmdheight = 1
vim.o.winborder = "solid"
-- stylua: ignore start
vim.api.nvim_create_autocmd("FileType", {
  pattern = {
    "c", "cpp", "lua", "python", "go", "rust", "bash", "fish", "json", "yaml", "toml",
    "html", "css", "markdown", "vim", "diff", "gitcommit", "gitignore", "gitattributes",
    "cmake", "ninja", "asm", "glsl", "zig", "nix", "nu", "kdl", "awk", "latex",
    "typst", "qmljs", "luadoc", "astro", "llvm", "vimdoc",
  },
  callback = function() vim.treesitter.start() end,
})
-- stylua: ignore end

vim.diagnostic.config({
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "●",
      [vim.diagnostic.severity.WARN] = "●",
      [vim.diagnostic.severity.INFO] = "●",
      [vim.diagnostic.severity.HINT] = "●",
    },
  },
  underline = false,
  virtual_text = false,
  update_in_insert = false,
  severity_sort = true,
})

-- vim.api.nvim_create_autocmd("LspProgress", {
--   group = vim.api.nvim_create_augroup("UserLspProgress", { clear = true }),
--   callback = function(ev)
--     local value = ev.data.params.value
--     vim.api.nvim_echo({ { value.message or "done" } }, false, {
--       id = "lsp." .. ev.data.client_id,
--       kind = "progress",
--       source = "vim.lsp",
--       title = value.title,
--       status = value.kind ~= "end" and "running" or "success",
--       percent = value.percentage,
--     })
--   end,
-- })
--
-- require("vim._core.ui2").enable({
--   enable = true,
--   msg = {
--     targets = {
--       progress = "msg",
--     },
--   },
-- })
