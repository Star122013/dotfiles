local gh = function(x) return "https://github.com/" .. x end

--=============================================================================
-- Theme
--=============================================================================
vim.pack.add({
  gh("folke/tokyonight.nvim"),
  gh("mvllow/modes.nvim"),
  { src = gh("catppuccin/nvim"), name = "catppuccin" },
})
require("tokyonight").setup({
  transparent = true,
})

local colors = require("tokyonight.colors").setup()
require("modes").setup({
  colors = {
    bg = "",
    copy = colors.yellow,
    delete = colors.git.delete,
    change = colors.git.change,
    format = colors.orange,
    insert = colors.cyan,
    replace = colors.teal,
    select = colors.purple,
    visual = colors.magenta2,
  },
})

require("catppuccin").setup({
  transparent_background = true, -- disables setting the background color.
  float = {
    transparent = true, -- enable transparent floating windows
    solid = true, -- use solid styling for floating windows, see |winborder|
  },
})
vim.cmd.colorscheme("catppuccin")
--=============================================================================
-- Core (mini.nvim suite - ai, pairs, tabline, pick, icons, extra)
--=============================================================================
vim.pack.add({
  gh("nvim-mini/mini.nvim"),
})

require("mini.ai").setup()
require("mini.pairs").setup()
require("mini.tabline").setup({
  show_icons = false,
})
-- require("mini.pick").setup()
require("mini.icons").setup()
-- require("mini.extra").setup()
require("mini.indentscope").setup()
require("mini.cursorword").setup()
require("mini.notify").setup()
-- require("mini.statusline").setup()
require("mini.clue").setup({
  triggers = {
    { mode = { "n", "x" }, keys = "<Leader>" },
    { mode = "n", keys = "[" },
    { mode = "n", keys = "]" },
    { mode = "i", keys = "<C-x>" },
    { mode = { "n", "x" }, keys = "g" },
    { mode = { "n", "x" }, keys = "'" },
    { mode = { "n", "x" }, keys = "`" },
    { mode = { "n", "x" }, keys = '"' },
    { mode = { "i", "c" }, keys = "<C-r>" },
    { mode = "n", keys = "<C-w>" },
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

vim.pack.add({ gh("nvim-telescope/telescope.nvim") })
vim.pack.add({ gh("nvim-telescope/telescope-fzf-native.nvim") })
vim.pack.add({ gh("nvim-lua/plenary.nvim") })

vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if name == "telescope-fzf-native.nvim" and kind == "update" then
      if not ev.data.active then
        vim.cmd.packadd("telescope-fzf-native.nvim")
      end
      vim.cmd("make")
    end
  end,
})

--=============================================================================
-- Syntax Highlighting (Treesitter)
--=============================================================================
vim.pack.add({ gh("nvim-treesitter/nvim-treesitter") })

--=============================================================================
-- Completion (blink.cmp + snippets)
--=============================================================================
vim.pack.add({
  { src = gh("saghen/blink.cmp"), version = "v1.10.2" },
  gh("rafamadriz/friendly-snippets"),
  gh("L3MON4D3/LuaSnip"),
  gh("xzbdmw/colorful-menu.nvim"),
  gh("supermaven-inc/supermaven-nvim"),
  { src = gh("saghen/blink.compat"), version = "v2.5.0" },
})

---@diagnostic disable-next-line: undefined-field
require("blink.cmp").setup({
  keymap = {
    preset = "none",
    ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
    ["<C-e>"] = { "hide", "fallback" },
    ["<CR>"] = { "accept", "fallback" },
    ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
    ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
    ["<Up>"] = { "select_prev", "fallback" },
    ["<Down>"] = { "select_next", "fallback" },
    ["<C-p>"] = { "select_prev", "fallback_to_mappings" },
    ["<C-n>"] = { "select_next", "fallback_to_mappings" },
    ["<C-u>"] = { "scroll_documentation_up", "fallback" },
    ["<C-d>"] = { "scroll_documentation_down", "fallback" },
    ["<C-k>"] = { "show_signature", "hide_signature", "fallback" },
  },
  appearance = { nerd_font_variant = "mono" },
  completion = {
    documentation = { auto_show = true },
    menu = {
      draw = {
        columns = {
          { "kind_icon", "label", "label_description", gap = 1 },
          { "kind", gap = 1, "source_id" },
        },
        treesitter = { "lsp" },
        padding = { 0, 1 }, -- padding only on right side
        components = {
          kind_icon = {
            text = function(ctx)
              return " " .. ctx.kind_icon .. ctx.icon_gap .. " "
            end,
          },
        },
      },
    },
    list = {
      selection = { preselect = false, auto_insert = false },
    },
  },
  sources = {
    default = { "lsp", "path", "supermaven", "snippets", "buffer" },
    providers = {
      supermaven = {
        name = "supermaven",
        module = "blink.compat.source",
        score_offset = 100,
        async = true,
      },
    },
  },
  cmdline = {
    completion = {
      menu = {
        auto_show = true,
      },
      list = {
        selection = { preselect = false, auto_insert = true },
      },
    },
  },
  fuzzy = {
    implementation = "prefer_rust",
    prebuilt_binaries = { force_version = "v1.10.1" },
  },
})

--=============================================================================
-- LSP (lspconfig + mason)
--=============================================================================
vim.pack.add({
  gh("neovim/nvim-lspconfig"),
})


vim.lsp.enable("emmylua_ls")
vim.lsp.enable("zls")
vim.lsp.enable("clangd")
vim.lsp.enable("gopls")
vim.lsp.enable("rust_analyzer")
vim.lsp.enable("dockerls")
vim.lsp.enable("nushell")
vim.lsp.enable("tinymist")
vim.lsp.enable("jsonls")

local home_manager_flake = "/var/home/cyrene/.config/home-manager"
vim.lsp.config("nixd", {
  cmd = { "nixd" },
  filetypes = { "nix" },
  settings = {
    nixd = {
      formatting = {
        command = { "nixfmt" },
      },
      nixpkgs = {
        expr = 'let flake = builtins.getFlake "' .. home_manager_flake .. '"; in import flake.inputs.nixpkgs { system = builtins.currentSystem; }',
      },
      options = {
        ["home-manager"] = {
          expr = '(builtins.getFlake "' .. home_manager_flake .. '").homeConfigurations.cyrene.options',
        },
      },
    },
  },
})
vim.lsp.enable("nixd")

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
  end,
})

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

--=============================================================================
-- Formatting & Linting (conform.nvim + nvim-lint)
--=============================================================================
vim.pack.add({
  gh("stevearc/conform.nvim"),
  gh("mfussenegger/nvim-lint"),
})

require("conform").setup({
  formatters_by_ft = { lua = { "stylua" } },
  format_on_save = { timeout_ms = 2000, lsp_fallback = true },
})

local lint = require("lint")
lint.linters_by_ft = {}

vim.api.nvim_create_autocmd("BufWritePost", {
  callback = function() lint.try_lint() end,
})

--=============================================================================
-- UI (lualine + diagnostic + code action)
--=============================================================================
vim.pack.add({
  gh("nvim-lualine/lualine.nvim"),
  gh("nvim-tree/nvim-web-devicons"),
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

vim.pack.add({ gh("rachartier/tiny-inline-diagnostic.nvim") })
require("tiny-inline-diagnostic").setup({
  preset = "compact",
  transparent_bg = true,
  signs = { enabled = false },
})

vim.pack.add({ gh("rachartier/tiny-code-action.nvim") })
require("tiny-code-action").setup({
  picker = "telescope",
})

--=============================================================================
-- tools 
--=============================================================================
vim.pack.add({ gh("chomosuke/typst-preview.nvim") })
require("typst-preview").setup()
