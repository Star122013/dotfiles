---@diagnostic disable: unused-local, redundant-parameter
local gh = function(x) return "https://github.com/" .. x end

--=============================================================================
-- LSP — lspconfig
--=============================================================================
vim.pack.add({
  gh("neovim/nvim-lspconfig"),
})

-- Collect plugin directories for lua_ls workspace library
local plugin_dirs = vim.fn.glob(
  vim.fn.stdpath("data") .. "/site/pack/core/opt/*/",
  false,
  true
)

vim.lsp.config("lua_ls", {
  on_init = function(client)
    if client.workspace_folders then
      local path = client.workspace_folders[1].name
      if vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc") then
        return
      end
    end
    client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
      runtime = {
        version = "LuaJIT",
        path = {
          "lua/?.lua",
          "lua/?/init.lua",
        },
      },
      workspace = {
        checkThirdParty = false,
        preloadFileSize = 100,
        library = vim.list_extend(
          { vim.env.VIMRUNTIME },
          plugin_dirs
        ),
      },
    })
  end,
  settings = {
    Lua = {},
  },
})
vim.lsp.enable("lua_ls")
vim.lsp.enable("zls")
vim.lsp.enable("clangd")
vim.lsp.enable("gopls")
vim.lsp.enable("rust_analyzer")
vim.lsp.enable("dockerls")
vim.lsp.enable("nushell")
vim.lsp.enable("tinymist")
vim.lsp.enable("jsonls")
vim.lsp.enable("ts_ls")

--=============================================================================
-- nixd — Nix LSP
--=============================================================================
local home_manager_flake = "/var/home/cyrene/.config/home-manager"
local flake_lock_path = home_manager_flake .. "/flake.lock"
local nixpkgs_expr = nil
local ok, lock = pcall(vim.fn.json_decode, vim.fn.readfile(flake_lock_path))
if ok then
  local n = lock.nodes.nixpkgs.locked
  if n.type == "github" then
    nixpkgs_expr = string.format(
      'import (builtins.fetchTree { type = "github"; owner = "%s"; repo = "%s"; rev = "%s"; narHash = "%s"; }) { system = builtins.currentSystem; }',
      n.owner, n.repo, n.rev, n.narHash
    )
  end
end

local nixpkgs_store_path = vim.fn.system("nix eval --impure --raw 'nixpkgs#path' 2>/dev/null"):gsub("%s+", "")
local nixd_cmd
if vim.v.shell_error == 0 and nixpkgs_store_path ~= "" then
  nixd_cmd = { "sh", "-c", "NIX_PATH=nixpkgs=" .. nixpkgs_store_path .. ":$NIX_PATH exec nixd" }
else
  nixd_cmd = { "nixd" }
end

local is_nixos = vim.fn.executable("nixos-rebuild") == 1 or vim.fn.filereadable("/etc/NIXOS") == 1

vim.lsp.config("nixd", {
  cmd = nixd_cmd,
  filetypes = { "nix" },
  settings = {
    nixd = {
      formatting = {
        command = { "nixfmt" },
      },
      nixpkgs = {
        expr = nixpkgs_expr,
      },
      options = (is_nixos and {
        nixos = {
          expr = '(builtins.getFlake "' .. home_manager_flake .. '").nixosConfigurations.system.options',
        },
        ["home-manager"] = {
          expr = '(builtins.getFlake "' .. home_manager_flake .. '").homeConfigurations.cyrene.options',
        },
      }) or {
        ["home-manager"] = {
          expr = '(builtins.getFlake "' .. home_manager_flake .. '").homeConfigurations.cyrene.options',
        },
      },
    },
  },
})
vim.lsp.enable("nixd")

--=============================================================================
-- LSP UX
--=============================================================================
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
-- Formatting & Linting
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
