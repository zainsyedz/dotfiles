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

-- Copy file references to clipboard
local function copy_file_reference(is_visual)
  local file = vim.fn.expand('%:p')
  local reference

  if is_visual then
    local start_line = vim.fn.line('v')
    local end_line = vim.fn.line('.')

    if start_line == 0 or end_line == 0 then
      start_line = vim.fn.line("'<")
      end_line = vim.fn.line("'>")
    end

    if start_line > end_line then
      start_line, end_line = end_line, start_line
    end

    if start_line == end_line then
      reference = file .. ':' .. start_line
    else
      reference = file .. ':' .. start_line .. '-' .. end_line
    end
  else
    local line = vim.fn.line('.')
    reference = file .. ':' .. line
  end

  vim.fn.setreg('+', reference)
  vim.notify('Copied: ' .. reference, vim.log.levels.INFO)
end

vim.keymap.set('n', '<leader>gr', function()
  copy_file_reference(false)
end, { desc = 'Grab reference (copy file:line to clipboard)' })

vim.keymap.set('x', '<leader>gr', function()
  copy_file_reference(true)
end, { desc = 'Grab reference (copy file:start-end to clipboard)' })
