--=============================================================================
-- Matugen Module: Dynamic colorscheme highlighting
-- Reads palette from generated-matugen.lua and applies Neovim highlights
--=============================================================================
local M = {}
local watcher = {
  fs = nil,
  timer = nil,
}

local function palette_path()
  return vim.fn.stdpath("config") .. "/lua/generated-matugen.lua"
end

local function palette_dir() return vim.fn.stdpath("config") .. "/lua" end

-- Picks the first non-empty value from tbl using keys array, returns fallback if none found
local function pick(tbl, keys, fallback)
  for _, key in ipairs(keys) do
    local value = tbl[key]
    if type(value) == "string" and value ~= "" then return value end
  end

  return fallback
end

-- Gets a base16 color value by key, with fallback
local function base16_color(base_16, key, fallback)
  local value = base_16[key]
  if type(value) == "string" and value ~= "" then return value end

  return fallback
end

-- Creates UI highlights for plugins (BlinkCmp, SnacksPicker)
local function make_shared_ui_highlights(colors, base_16)
  local blink_bg = "NONE"
  local cursor_line_nr = { fg = colors.cursor_line_nr or colors.orange }
  if colors.bold_style ~= nil then cursor_line_nr.style = colors.bold_style end
  if colors.bold ~= nil then cursor_line_nr.bold = colors.bold end

  local bg_ui = base16_color(base_16, "base01", "#1f1b16")
  local fg_ui = base16_color(base_16, "base05", "#ebe1d9")

  return {
NormalFloat = { fg = colors.fg1, bg = "NONE" },
    FloatBorder = { fg = colors.comment, bg = "NONE" },
    FloatTitle = { fg = colors.fg1, bg = colors.none },

    CursorLine = { bg = colors.bg2 },
    CursorLineNr = cursor_line_nr,
    Cursor = { bg = colors.cursor_bg, fg = colors.cursor_fg },
    TermCursor = { bg = colors.cursor_bg, fg = colors.cursor_fg },

    BlinkCmpMenu = { bg = "NONE" },
    BlinkCmpMenuBorder = { fg = colors.comment, bg = "NONE" },
    BlinkCmpMenuSelection = {
      fg = fg_ui,
      bg = base16_color(base_16, "base03", "#4f4539"),
      bold = true,
    },
    BlinkCmpLabel = { fg = colors.fg1, bg = "NONE" },
    BlinkCmpLabelMatch = { fg = colors.blue, bg = "NONE", bold = true },
    BlinkCmpLabelDeprecated = {
      fg = colors.comment,
      bg = "NONE",
      strikethrough = true,
    },
    BlinkCmpLabelDetail = { fg = colors.comment, bg = "NONE" },
    BlinkCmpLabelDescription = { fg = colors.comment, bg = "NONE" },
    BlinkCmpSource = { fg = colors.comment, bg = "NONE" },
    BlinkCmpKind = { fg = colors.fg1, bg = "NONE" },
    BlinkCmpScrollBarThumb = { bg = "NONE" },
    BlinkCmpScrollBarGutter = { bg = "NONE" },
    BlinkCmpDoc = { bg = "NONE" },
    BlinkCmpDocBorder = { fg = colors.comment, bg = "NONE" },
    BlinkCmpDocSeparator = { fg = colors.comment, bg = "NONE" },
    BlinkCmpDocCursorLine = { bg = base16_color(base_16, "base03", "#4f4539") },
    BlinkCmpSignatureHelp = { bg = "NONE" },
    BlinkCmpSignatureHelpBorder = { fg = colors.comment, bg = "NONE" },

    SnacksPicker = { bg = "NONE" },
    SnacksPickerBorder = {
      fg = colors.picker_border or colors.none,
      bg = "NONE",
    },
    SnacksPickerBoxBorder = {
      fg = colors.picker_border or colors.none,
      bg = "NONE",
    },
    SnacksPickerInputBorder = {
      fg = colors.picker_border or colors.none,
      bg = "NONE",
    },
    SnacksPickerPreviewBorder = {
      fg = colors.picker_border or colors.none,
      bg = "NONE",
    },
    SnacksPickerTitle = { fg = colors.fg1, bg = "NONE" },
    SnacksPickerBoxTitle = { fg = colors.fg1, bg = "NONE" },
    SnacksPickerInputTitle = { fg = colors.fg1, bg = "NONE" },
    SnacksPickerPreviewTitle = { fg = colors.fg1, bg = "NONE" },
    SnacksPickerPrompt = { bg = "NONE" },
    SnacksPickerInput = { bg = "NONE" },
    SnacksPickerList = { bg = "NONE" },
    SnacksPickerPreview = { bg = "NONE" },
  }
end

-- Creates syntax color palette from base16/base30 color schemes
local function make_syntax_palette(base_16, base_30)
  return {
    bg = base16_color(
      base_16,
      "base00",
      pick(base_30, { "black", "darker_black" }, "#1E1D2D")
    ),
    bg_alt = base16_color(
      base_16,
      "base01",
      pick(base_30, { "one_bg", "black2", "one_bg2" }, "#282737")
    ),
    bg_visual = base16_color(
      base_16,
      "base02",
      pick(base_30, { "one_bg2", "one_bg3", "black2" }, "#414050")
    ),
    fg = base16_color(
      base_16,
      "base05",
      pick(base_30, { "white", "light_grey", "grey_fg2" }, "#D9E0EE")
    ),
    fg_soft = base16_color(
      base_16,
      "base04",
      pick(base_30, { "light_grey", "grey_fg2", "grey_fg" }, "#bfc6d4")
    ),
    comment = pick(
      base_30,
      { "grey_fg", "grey", "grey_fg2" },
      base16_color(base_16, "base03", "#6E6A86")
    ),
    gutter = base16_color(
      base_16,
      "base03",
      pick(base_30, { "grey", "line", "grey_fg" }, "#5B5775")
    ),
    red = base16_color(base_16, "base08", pick(base_30, { "red" }, "#F38BA8")),
    orange = base16_color(
      base_16,
      "base09",
      pick(base_30, { "orange", "sun" }, "#F8BD96")
    ),
    yellow = base16_color(
      base_16,
      "base0A",
      pick(base_30, { "yellow", "sun" }, "#FAE3B0")
    ),
    green = base16_color(
      base_16,
      "base0B",
      pick(base_30, { "green", "vibrant_green" }, "#ABE9B3")
    ),
    cyan = base16_color(
      base_16,
      "base0C",
      pick(base_30, { "cyan", "teal" }, "#89DCEB")
    ),
    blue = base16_color(
      base_16,
      "base0D",
      pick(base_30, { "blue", "nord_blue" }, "#89B4FA")
    ),
    purple = base16_color(
      base_16,
      "base0E",
      pick(base_30, { "purple", "pink" }, "#CBA6F7")
    ),
    pink = base16_color(
      base_16,
      "base0F",
      pick(base_30, { "pink", "baby_pink" }, "#F5C2E7")
    ),
  }
end

-- Creates all internal Neovim highlights (syntax, diagnostics, LSP, etc.)
local function make_internal_highlights(base_16, base_30)
  local c = make_syntax_palette(base_16, base_30)

  return {
    Normal = { fg = c.fg, bg = c.bg },
    NormalNC = { fg = c.fg, bg = c.bg },
    MiniPickNormal = { bg = "NONE" },
    MiniPickMatchCurrent = { fg = c.fg, bg = base16_color(base_16, "base03", "#4f4539") },
    MiniPickCursor = { fg = base16_color(base_16, "base05", "#ebe1d9"), bg = base16_color(base_16, "base03", "#4f4539") },
    MiniPickItemSelected = { fg = base16_color(base_16, "base05", "#ebe1d9"), bg = base16_color(base_16, "base03", "#4f4539"), bold = true },

    Pmenu = { bg = "NONE" },
    PmenuSel = { bg = base16_color(base_16, "base03", "#4f4539") },
    PmenuThumb = { bg = "NONE" },
    PmenuSbar = { bg = "NONE" },
    NonText = { fg = c.gutter },
    Whitespace = { fg = c.gutter },
    SignColumn = { fg = c.gutter, bg = c.bg },
    EndOfBuffer = { fg = c.bg, bg = c.bg },
    LineNr = { fg = c.gutter, bg = c.bg },
    CursorLineNr = { fg = c.blue, bold = true },
    CursorLine = { bg = c.bg_alt },
    ColorColumn = { bg = c.bg_alt },
    Visual = { bg = c.bg_visual },
    Search = { fg = c.bg, bg = c.yellow, bold = true },
    IncSearch = { fg = c.bg, bg = c.orange, bold = true },
    MatchParen = { fg = c.blue, bg = c.bg_visual, bold = true },
    StatusLine = { fg = c.fg_soft, bg = c.bg_alt },
    StatusLineNC = { fg = c.comment, bg = c.bg_alt },

    Comment = { fg = c.comment, italic = true },
    Constant = { fg = c.orange },
    String = { fg = c.green },
    Character = { fg = c.red },
    Number = { fg = c.orange },
    Boolean = { fg = c.orange },
    Float = { fg = c.orange },
    Variable = { fg = c.fg },
    Identifier = { fg = c.red },
    Function = { fg = c.blue },
    Statement = { fg = c.red },
    Conditional = { fg = c.purple },
    Repeat = { fg = c.yellow },
    Label = { fg = c.yellow },
    Operator = { fg = c.fg },
    Keyword = { fg = c.purple },
    Exception = { fg = c.red },
    PreProc = { fg = c.yellow },
    Include = { fg = c.blue },
    Define = { fg = c.purple },
    Macro = { fg = c.red },
    PreCondit = { fg = c.yellow },
    Type = { fg = c.yellow },
    StorageClass = { fg = c.yellow },
    Structure = { fg = c.purple },
    Typedef = { fg = c.yellow },
    Special = { fg = c.cyan },
    SpecialChar = { fg = c.pink },
    Tag = { fg = c.yellow },
    Delimiter = { fg = c.fg_soft },
    SpecialComment = { fg = c.comment },
    Debug = { fg = c.red },
    Underlined = { fg = c.blue, underline = true },
    Error = { fg = c.red },
    ErrorMsg = { fg = c.red },
    WarningMsg = { fg = c.yellow },
    Todo = { fg = c.yellow, bg = c.bg_alt, bold = true },

    DiagnosticError = { fg = "#ef4444" },
    DiagnosticWarn = { fg = "#eab308" },
    DiagnosticInfo = { fg = "#3b82f6" },
    DiagnosticHint = { fg = "#3b82f6" },
    DiagnosticUnderlineError = { undercurl = true, sp = "#ef4444" },
    DiagnosticUnderlineWarn = { undercurl = true, sp = "#eab308" },
    DiagnosticUnderlineInfo = { undercurl = true, sp = "#3b82f6" },
    DiagnosticUnderlineHint = { undercurl = true, sp = "#3b82f6" },

    BlinkPairsRed = { fg = c.red },
    BlinkPairsYellow = { fg = c.yellow },
    BlinkPairsBlue = { fg = c.blue },
    BlinkPairsOrange = { fg = c.orange },
    BlinkPairsGreen = { fg = c.green },
    BlinkPairsPurple = { fg = c.purple },
    BlinkPairsCyan = { fg = c.cyan },
    BlinkPairsUnmatched = { fg = c.red, bold = true },

    SnacksIndent = { fg = c.gutter },
    SnacksIndentScope = { fg = c.blue },
    SnacksIndentChunk = { fg = c.purple },
    SnacksIndent1 = { fg = c.red },
    SnacksIndent2 = { fg = c.yellow },
    SnacksIndent3 = { fg = c.blue },
    SnacksIndent4 = { fg = c.orange },
    SnacksIndent5 = { fg = c.green },
    SnacksIndent6 = { fg = c.purple },
    SnacksIndent7 = { fg = c.cyan },
    SnacksIndent8 = { fg = c.pink },

    ["@comment"] = { link = "Comment" },
    ["@comment.documentation"] = { fg = c.comment, italic = true },
    ["@comment.todo"] = { fg = c.comment, bg = c.fg, bold = true },
    ["@comment.warning"] = { fg = c.bg_alt, bg = c.orange, bold = true },
    ["@comment.note"] = { fg = c.bg, bg = c.blue, bold = true },
    ["@comment.danger"] = { fg = c.bg_alt, bg = c.red, bold = true },

    ["@string"] = { fg = c.green },
    ["@string.regex"] = { fg = c.cyan },
    ["@string.escape"] = { fg = c.cyan },
    ["@character"] = { fg = c.red },
    ["@number"] = { fg = c.orange },
    ["@number.float"] = { fg = c.orange },
    ["@boolean"] = { fg = c.orange },
    ["@constant"] = { fg = c.orange },
    ["@constant.builtin"] = { fg = c.orange },
    ["@constant.macro"] = { fg = c.red },
    ["@variable"] = { fg = c.fg },
    ["@variable.builtin"] = { fg = c.orange },
    ["@variable.parameter"] = { fg = c.red },
    ["@variable.member"] = { fg = c.red },
    ["@variable.member.key"] = { fg = c.red },
    ["@module"] = { fg = c.red },
    ["@property"] = { fg = c.red },

    ["@function"] = { fg = c.blue },
    ["@function.builtin"] = { fg = c.blue },
    ["@function.macro"] = { fg = c.red },
    ["@function.call"] = { fg = c.blue },
    ["@function.method"] = { fg = c.blue },
    ["@function.method.call"] = { fg = c.blue },
    ["@method"] = { fg = c.blue },
    ["@constructor"] = { fg = c.cyan },

    ["@keyword"] = { fg = c.purple },
    ["@keyword.return"] = { fg = c.purple },
    ["@keyword.function"] = { fg = c.purple },
    ["@keyword.operator"] = { fg = c.purple },
    ["@keyword.conditional"] = { fg = c.purple },
    ["@keyword.conditional.ternary"] = { fg = c.purple },
    ["@keyword.repeat"] = { fg = c.yellow },
    ["@keyword.storage"] = { fg = c.yellow },
    ["@keyword.directive"] = { fg = c.yellow },
    ["@keyword.directive.define"] = { fg = c.purple },
    ["@keyword.import"] = { link = "Include" },

    ["@type"] = { fg = c.yellow },
    ["@type.builtin"] = { fg = c.yellow },
    ["@namespace"] = { fg = c.red },
    ["@operator"] = { fg = c.fg },
    ["@punctuation.delimiter"] = { fg = c.fg_soft },
    ["@punctuation.bracket"] = { fg = c.fg_soft },
    ["@punctuation.special"] = { fg = c.fg_soft },
    ["@symbol"] = { fg = c.green },
    ["@tag"] = { fg = c.yellow },
    ["@tag.attribute"] = { fg = c.red },
    ["@tag.delimiter"] = { fg = c.pink },
    ["@text"] = { fg = c.fg },
    ["@text.emphasis"] = { fg = c.orange },
    ["@text.strike"] = { fg = c.pink, strikethrough = true },

    ["@lsp.type.class"] = { link = "Structure" },
    ["@lsp.type.decorator"] = { link = "Function" },
    ["@lsp.type.enum"] = { link = "Type" },
    ["@lsp.type.enumMember"] = { link = "Constant" },
    ["@lsp.type.function"] = { link = "@function" },
    ["@lsp.type.interface"] = { link = "Structure" },
    ["@lsp.type.macro"] = { link = "Macro" },
    ["@lsp.type.method"] = { link = "@function.method" },
    ["@lsp.type.namespace"] = { link = "@module" },
    ["@lsp.type.parameter"] = { link = "@variable.parameter" },
    ["@lsp.type.property"] = { link = "@property" },
    ["@lsp.type.struct"] = { link = "Structure" },
    ["@lsp.type.type"] = { link = "@type" },
    ["@lsp.type.typeParameter"] = { link = "Typedef" },
    ["@lsp.type.typeParamater"] = { link = "Typedef" },
    ["@lsp.type.variable"] = { link = "@variable" },
    ["@event"] = { fg = c.red },
    ["@modifier"] = { fg = c.red },
    ["@regexp"] = { fg = c.pink },
  }
end

-- Normalizes palette by selecting dark/light variant based on vim.o.background
local function normalize_palette(palette)
  if type(palette) ~= "table" then return nil end

  if palette.enabled == false then return nil end

  local has_variants = type(palette.dark) == "table"
    or type(palette.light) == "table"
  if has_variants then
    local variant = vim.o.background == "light" and "light" or "dark"
    palette = palette[variant]
  end

  if type(palette) ~= "table" or palette.enabled == false then return nil end

  local base_16 = palette.base_16 or palette.base16 or {}
  local base_30 = palette.base_30 or palette.base30

  if type(base_16) ~= "table" or type(base_30) ~= "table" then return nil end

  return {
    base_16 = base_16,
    base_30 = base_30,
  }
end

-- Loads palette from generated-matugen.lua file
local function load_palette()
  local path = palette_path()
  ---@diagnostic disable-next-line: deprecated, undefined-field
  if (vim.uv or vim.loop).fs_stat(path) == nil then return nil end

  local ok, palette = pcall(dofile, path)
  if not ok then return nil end

  return normalize_palette(palette)
end

-- Applies all highlights to Neovim and triggers User event
local function apply_highlights()
  local palette = load_palette()
  if not palette then return end

  local base_16 = palette.base_16
  local base_30 = palette.base_30

  local syntax_highlights = make_internal_highlights(base_16, base_30)
  for group, opts in pairs(syntax_highlights) do
    vim.api.nvim_set_hl(0, group, opts)
  end

  local ui_colors = {
    comment = pick(
      base_30,
      { "grey", "grey_fg", "grey_fg2" },
      base16_color(base_16, "base03", "#504945")
    ),
    fg1 = pick(
      base_30,
      { "white", "light_grey" },
      base16_color(base_16, "base05", "#d4be98")
    ),
    bg2 = pick(
      base_30,
      { "one_bg", "black2", "one_bg2" },
      base16_color(base_16, "base01", "#282828")
    ),
    cursor_bg = pick(
      base_30,
      { "white", "light_grey" },
      base16_color(base_16, "base05", "#d4be98")
    ),
    cursor_fg = pick(
      base_30,
      { "black", "darker_black" },
      base16_color(base_16, "base00", "#1d2021")
    ),
    red = pick(base_30, { "red" }, base16_color(base_16, "base08", "#ea6962")),
    yellow = pick(
      base_30,
      { "yellow", "sun" },
      base16_color(base_16, "base0A", "#d8a657")
    ),
    blue = pick(
      base_30,
      { "blue", "nord_blue" },
      base16_color(base_16, "base0D", "#7daea3")
    ),
    orange = pick(
      base_30,
      { "orange" },
      base16_color(base_16, "base09", "#e78a4e")
    ),
    green = pick(
      base_30,
      { "green", "vibrant_green" },
      base16_color(base_16, "base0B", "#a9b665")
    ),
    purple = pick(
      base_30,
      { "purple", "pink" },
      base16_color(base_16, "base0E", "#d3869b")
    ),
    cyan = pick(
      base_30,
      { "cyan", "teal" },
      base16_color(base_16, "base0C", "#89b482")
    ),
    picker_border = pick(
      base_30,
      { "line", "one_bg3", "statusline_bg" },
      base16_color(base_16, "base02", "#3c3836")
    ),
    cursor_line_nr = pick(
      base_30,
      { "nord_blue", "blue", "light_grey" },
      base16_color(base_16, "base0D", "#7daea3")
    ),
    bold = true,
    none = "NONE",
  }

  local ui_highlights = make_shared_ui_highlights(ui_colors, base_16)
  for group, opts in pairs(ui_highlights) do
    vim.api.nvim_set_hl(0, group, opts)
  end

  vim.schedule(
    function()
      vim.api.nvim_exec_autocmds("User", { pattern = "MatugenPaletteUpdated" })
    end
  )
end

-- Stops the fs watcher and timer
local function stop_watcher()
  if watcher.fs ~= nil then
    watcher.fs:stop()
    watcher.fs:close()
    watcher.fs = nil
  end

  if watcher.timer ~= nil then
    watcher.timer:stop()
    watcher.timer:close()
    watcher.timer = nil
  end
end

-- Starts watching for changes to generated-matugen.lua and reloads highlights
local function start_watcher()
  local uv = vim.uv or vim.loop
  if uv == nil or watcher.fs ~= nil then return end

  if uv.fs_stat(palette_dir()) == nil then return end

  watcher.timer = uv.new_timer()
  watcher.fs = uv.new_fs_event()
  if watcher.fs == nil then return end

  watcher.fs:start(palette_dir(), {}, function(err, filename)
    if err ~= nil or filename ~= "generated-matugen.lua" then return end

    if watcher.timer == nil then
      vim.schedule(apply_highlights)
      return
    end

    watcher.timer:stop()
    watcher.timer:start(120, 0, function() vim.schedule(apply_highlights) end)
  end)
end

-- Main setup function, call once during init
function M.setup()
  local group =
    vim.api.nvim_create_augroup("MatugenHighlights", { clear = true })

  vim.api.nvim_create_autocmd("ColorScheme", {
    group = group,
    pattern = "*",
    callback = apply_highlights,
  })

  vim.api.nvim_create_autocmd("VimLeavePre", {
    group = group,
    pattern = "*",
    callback = stop_watcher,
  })

  start_watcher()
  apply_highlights()
end

return M
