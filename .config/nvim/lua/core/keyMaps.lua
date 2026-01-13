-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- vim.keymap.set('n', '<C-v>', '<C-w>v', { desc = 'Split pane vertically' })
-- vim.keymap.set('n', '<C-s>', '<C-w>s', { desc = 'Split pane horizontally' })

-- Keybinds for tabs
vim.keymap.set('n', '<leader>to', '<cmd>tabnew<CR>', { desc = 'Open New Tab' }) -- open new tab
vim.keymap.set('n', '<leader>tx', '<cmd>tabclose<CR>', { desc = 'Close Current New Tab' }) -- close current tab
vim.keymap.set('n', '<leader>tn', '<cmd>tabn<CR>', { desc = 'Go to next tab' }) -- Go to next tab
vim.keymap.set('n', '<leader>tp', '<cmd>tabp<CR>', { desc = 'Go to previous  tab' }) -- Go to previous tab

-- Copy file reference (filename:line_number) to clipboard
vim.keymap.set('n', '<leader>gr', function()
  local file = vim.fn.expand('%')
  local line = vim.fn.line('.')
  local reference = file .. ':' .. line
  vim.fn.setreg('+', reference)
  vim.notify('Copied: ' .. reference, vim.log.levels.INFO)
end, { desc = 'Grab reference (copy file:line to clipboard)' })
