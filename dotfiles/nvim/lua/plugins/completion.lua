---@diagnostic disable: unused-local, redundant-parameter
local gh = function(x) return "https://github.com/" .. x end

--=============================================================================
-- Completion — blink.cmp
--=============================================================================
vim.pack.add({
  { src = gh("saghen/blink.cmp"), version = "v1.10.2" },
  gh("rafamadriz/friendly-snippets"),
  gh("xzbdmw/colorful-menu.nvim"),
})

local icons = {
  Array         = "",
  Boolean       = "",
  Class         = "",
  Color         = "",
  Constant      = "",
  Constructor   = "",
  Enum          = "",
  EnumMember    = "",
  Event         = "",
  Field         = "",
  File          = "",
  Folder        = "",
  Function      = "",
  Interface     = "",
  Key           = "",
  Keyword       = "",
  Method        = "",
  Module        = "",
  Namespace     = "",
  Null          = "󰟢",
  Number        = "",
  Object        = "",
  Operator      = "",
  Package       = "",
  Property      = "",
  Reference     = "",
  Snippet       = "",
  String        = "",
  Struct        = "",
  Text          = "",
  TypeParameter = "",
  Unit          = "",
  Value         = "",
  Variable      = "",
}

require("blink.cmp").setup({
  keymap = {
    preset        = "none",
    ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
    ["<C-e>"]     = { "hide", "fallback" },
    ["<CR>"]      = { "accept", "fallback" },
    ["<Tab>"]     = { "select_next", "snippet_forward", "fallback" },
    ["<S-Tab>"]   = { "select_prev", "snippet_backward", "fallback" },
    ["<Up>"]      = { "select_prev", "fallback" },
    ["<Down>"]    = { "select_next", "fallback" },
    ["<C-p>"]     = { "select_prev", "fallback" },
    ["<C-n>"]     = { "select_next", "fallback" },
    ["<C-u>"]     = { "scroll_documentation_up", "fallback" },
    ["<C-d>"]     = { "scroll_documentation_down", "fallback" },
    ["<C-k>"]     = { "show_signature", "hide_signature", "fallback" },
  },
  appearance = { nerd_font_variant = "mono" },
  completion = {
    documentation = { auto_show = true },
    menu = {
      draw = {
        columns = {
          { "label", gap = 1 },
          { "kind",  gap = 1, "source_id" },
        },
        components = {
          kind = {
            text = function(ctx)
              local icon = icons[ctx.kind] or ""
              return icon .. " " .. ctx.kind
            end,
          },
          source_id = {
            text = function(ctx)
              local labels = {
                lsp = "[LSP]", snippets = "[Sni]", path = "[Pth]", buffer = "[Buf]",
              }
              return labels[ctx.source_id] or ""
            end,
          },
          label = {
            text = function(ctx)
              return ctx.label
            end,
            highlight = function(ctx)
              local highlights = {}
              for _, idx in ipairs(ctx.label_matched_indices) do
                table.insert(highlights, { idx, idx + 1, group = "BlinkCmpLabelMatch" })
              end
              return highlights
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
    default = { "lsp", "path", "snippets", "buffer" },
  },
  cmdline = {
    completion = {
      menu = { auto_show = true },
      list = { selection = { preselect = false, auto_insert = false } },
    },
  },
  fuzzy = {
    implementation = "prefer_rust",
    prebuilt_binaries = { force_version = "v1.10.2" },
  },
})
