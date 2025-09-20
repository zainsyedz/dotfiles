return {
  'danymat/neogen',
  config = function()
    require('neogen').setup {
      enabled = true,
      input_after_comment = true,
    }
    vim.keymap.set('n', '<leader>gs', ':Neogen<CR>', { desc = '[G]enereate [S]nippet' })
  end,
  version = '*',
}
