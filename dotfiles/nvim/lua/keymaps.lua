vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- stylua: ignore start
vim.keymap.set("i", "<C-h>", "<Left>", { noremap = true, silent = true, desc = "Move Left" })
vim.keymap.set("i", "<C-j>", "<Down>", { noremap = true, silent = true, desc = "Move Down" })
vim.keymap.set("i", "<C-k>", "<Up>", { noremap = true, silent = true, desc = "Move Up" })
vim.keymap.set("i", "<C-l>", "<Right>", { noremap = true, silent = true, desc = "Move Right" })
vim.keymap.set("n", "<C-z>", "u", { noremap = true, silent = true, desc = "Undo" })

vim.keymap.set("n", "<Leader>ff", function() require('telescope.builtin').find_files() end, { desc = "Find files" })
vim.keymap.set("n", "<Leader>fg", function() require('telescope.builtin').live_grep() end, { desc = "Grep" })
vim.keymap.set("n", "<Leader>fb", function() require('telescope.builtin').buffers() end, { desc = "Buffers" })
vim.keymap.set("n", "<Leader>fh", function() require('telescope.builtin').help_tags() end, { desc = "Help tags" })
vim.keymap.set("n", "<Leader>fc", function() require('telescope.builtin').commands() end, { desc = "Commands" })
vim.keymap.set("n", "<Leader>fr", function() require('telescope.builtin').registers() end, { desc = "Registers" })
vim.keymap.set("n", "<Leader>fk", function() require('telescope.builtin').keymaps() end, { desc = "Keymaps" })
vim.keymap.set("n", "<Leader>fl", function() require('telescope.builtin').current_buffer_fuzzy_find() end, { desc = "Lines (buffer)" })
vim.keymap.set("n", "<Leader>fd", function() require('telescope.builtin').diagnostics() end, { desc = "Diagnostics" })
vim.keymap.set("n", "<Leader>fw", function() require('telescope.builtin').grep_string({ search = vim.fn.expand "<cword>" }) end, { desc = "Grep word" })

vim.keymap.set("n", "<Leader>gd", function() require('telescope.builtin').lsp_definitions({ jump_type = "never" }) end, { desc = "Goto Definition" })
vim.keymap.set("n", "<Leader>gr", function() require('telescope.builtin').lsp_references({ jump_type = "never" }) end, { desc = "Goto References" })
vim.keymap.set("n", "<Leader>gI", function() require('telescope.builtin').lsp_implementations({ jump_type = "never" }) end, { desc = "Goto Implementation" })
vim.keymap.set("n", "<Leader>gD", function() require('telescope.builtin').lsp_document_symbols({ jump_type = "never" }) end, { desc = "Document Symbols" })
vim.keymap.set("n", "<Leader>gW", function() require('telescope.builtin').lsp_workspace_symbols({ jump_type = "never" }) end, { desc = "Workspace Symbols" })
vim.keymap.set("n", "<Leader>gt", function() require('telescope.builtin').lsp_type_definitions({ jump_type = "never" }) end, { desc = "Goto Type Definition" })
vim.keymap.set({ "n", "x" }, "<leader>ca", function() require("tiny-code-action").code_action() end, { noremap = true, silent = true })
vim.keymap.set("n", "<Leader>fe", function() require("mini.files").open() end, { desc = "Explorer (mini.files)" })
vim.keymap.set("n", "<Leader>fH", function() require("mini.files").open(vim.fn.expand "~") end, { desc = "Explorer (mini.files) home" })

vim.keymap.set({ "n", "x" }, "<leader>ap", function() require("sidekick.cli").prompt() end, { desc = "Sidekick prompt…" })
vim.keymap.set({ "n", "x" }, "<leader>as", function() require("sidekick.cli").select() end, { desc = "Sidekick select CLI" })
vim.keymap.set({ "n", "t" }, "<c-.>", function() require("sidekick.cli").focus() end, { desc = "Sidekick focus" })
vim.keymap.set("n", "<leader>aa", function() require("sidekick.cli").toggle() end, { desc = "Sidekick toggle CLI" })
-- You may want these if you use the opinionated `<C-a>` and `<C-x>` keymaps above — otherwise consider `<leader>o…` (and remove terminal mode from the `toggle` keymap)
vim.keymap.set("n", "+", "<C-a>", { desc = "Increment under cursor", noremap = true })
vim.keymap.set("n", "-", "<C-x>", { desc = "Decrement under cursor", noremap = true })
