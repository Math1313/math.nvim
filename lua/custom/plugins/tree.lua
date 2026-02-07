local function my_on_attach(bufnr)
  local api = require 'nvim-tree.api'

  local function opts(desc) return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true } end

  --default configuration
  api.config.mappings.default_on_attach(bufnr)

  -- custom mappings
  -- -- Clean old mappings if it has one
  vim.keymap.del('n', '<C-t>', { buffer = bufnr })

  -- -- Define new custom mappings
  vim.keymap.set('n', '<C-t>', api.tree.toggle) -- Toggle the Tree Buffer on the left
  vim.keymap.set('n', '<C-d>', api.tree.change_root_to_parent) -- Change root of Tree buffer to parent folder
  vim.keymap.set('n', '<C-u>', api.tree.change_root_to_node) -- Change root of Tree buffer to highlighted folder
end

return {
  'nvim-tree/nvim-tree.lua',
  version = '*',
  lazy = false,
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  config = function()
    require('nvim-tree').setup {
      on_attach = my_on_attach,
    }
  end,
}
