-- mini.ai
local gen_ai_spec = require('mini.extra').gen_ai_spec
require('mini.ai').setup {
  custom_textobjects = {
    B = gen_ai_spec.buffer(),
    D = gen_ai_spec.diagnostic(),
    I = gen_ai_spec.indent(),
    L = gen_ai_spec.line(),
    N = gen_ai_spec.number(),
  },
}

-- mini.trailspace
require('mini.trailspace').setup {
  only_in_normal_buffers = true,
}
vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = '*',
  callback = function()
    MiniTrailspace.trim()
  end,
})

require('mini.animate').setup()
require('mini.bracketed').setup()
require('mini.comment').setup()
require('mini.cursorword').setup()
require('mini.icons').setup()
require('mini.indentscope').setup()
require('mini.input').setup()
require('mini.move').setup()
require('mini.operators').setup()
require('mini.pairs').setup()
require('mini.splitjoin').setup()
require('mini.surround').setup()

require('tree-sitter-manager').setup {
  auto_install = true, -- auto-install when a new filetype is encountered
}
