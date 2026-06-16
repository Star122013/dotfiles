---@diagnostic disable: unused-local, redundant-parameter
local gh = function(x) return "https://github.com/" .. x end

--=============================================================================
-- Core — mini.nvim modules
--=============================================================================
vim.pack.add({
  gh("nvim-mini/mini.ai"),
  gh("nvim-mini/mini.pairs"),
  gh("nvim-mini/mini.indentscope"),
  gh("nvim-mini/mini.cursorword"),
  gh("nvim-mini/mini.clue"),
  gh("nvim-mini/mini.files"),
})

require("mini.ai").setup()
require("mini.pairs").setup()

require("mini.indentscope").setup()
require("mini.cursorword").setup()

require("mini.clue").setup({
  triggers = {
    { mode = { "n", "x" }, keys = "<Leader>" },
    { mode = "n",          keys = "[" },
    { mode = "n",          keys = "]" },
    { mode = "i",          keys = "<C-x>" },
    { mode = { "n", "x" }, keys = "g" },
    { mode = { "n", "x" }, keys = "'" },
    { mode = { "n", "x" }, keys = "`" },
    { mode = { "n", "x" }, keys = '"' },
    { mode = { "i", "c" }, keys = "<C-r>" },
    { mode = "n",          keys = "<C-w>" },
    { mode = { "n", "x" }, keys = "z" },
  },
  clues = {
    require("mini.clue").gen_clues.square_brackets(),
    require("mini.clue").gen_clues.builtin_completion(),
    require("mini.clue").gen_clues.g(),
    require("mini.clue").gen_clues.marks(),
    require("mini.clue").gen_clues.registers(),
    require("mini.clue").gen_clues.windows(),
    require("mini.clue").gen_clues.z(),
  },
  window = { delay = 100 },
})

require("mini.files").setup({
  options = {
    permanent_delete = false,
    use_as_explorer = true,
  },
})

--=============================================================================
-- Telescope
--=============================================================================
vim.pack.add({ gh("nvim-telescope/telescope.nvim") })
vim.pack.add({ gh("nvim-telescope/telescope-fzf-native.nvim") })
vim.pack.add({ gh("nvim-lua/plenary.nvim") })
vim.pack.add({ gh("nvim-tree/nvim-web-devicons") })

require("telescope").setup({
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = "smart_case",
    },
  },
})

-- Build fzf native .so if missing, then load extension.
-- The PackChanged autocmd below handles updates; this covers first install.
vim.schedule(function()
  local fzf_dir = vim.fn.stdpath("data") .. "/site/pack/core/opt/telescope-fzf-native.nvim"
  local lib = fzf_dir .. "/build/libfzf." .. (vim.fn.has("win32") == 1 and "dll" or "so")
  if vim.fn.filereadable(lib) == 0 then
    vim.cmd("cd " .. fzf_dir .. " | make")
  end
  pcall(function() require("telescope").load_extension("fzf") end)
end)

vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if name == "telescope-fzf-native.nvim" and (kind == "add" or kind == "update") then
      if not ev.data.active then
        vim.cmd.packadd("telescope-fzf-native.nvim")
      end
      vim.cmd("make")
    end
  end,
})

--=============================================================================
-- Syntax Highlighting — Treesitter
--=============================================================================
vim.pack.add {
  gh("romus204/tree-sitter-manager.nvim"),
}

require("tree-sitter-manager").setup({
  ensure_installed = {
    "lua", "nix", "vim", "vimdoc", "c", "cpp", "go", "rust", "python",
    "bash", "json", "yaml", "toml", "html", "css", "markdown",
    "diff", "cmake", "glsl", "zig", "nu", "typst", "regex",
  },
  auto_install = true,
  highlight = true,
})
