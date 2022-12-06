-- Custom keymaps
--- Get out without Esc
vim.keymap.set({'i', 'v'}, 'jk', '<Esc>', { desc = 'Escape back to normal mode' })
vim.keymap.set('t', 'jk', '<C-\\><C-n>', { desc = 'Escape back to normal mode'})

--- Change window pane by direction
vim.keymap.set('n', '<C-k>', '<C-W>k', {})
vim.keymap.set('n', '<C-h>', '<C-W>h', {})
vim.keymap.set('n', '<C-j>', '<C-W>j', {})
vim.keymap.set('n', '<C-l>', '<C-W>l', {})

---- Change even in Terminal
vim.keymap.set('t', '<C-k>', '<C-\\><C-n><C-W>k', {})
vim.keymap.set('t', '<C-h>', '<C-\\><C-n><C-W>h', {})
vim.keymap.set('t', '<C-j>', '<C-\\><C-n><C-W>j', {})
vim.keymap.set('t', '<C-l>', '<C-\\><C-n><C-W>l', {})

--- Change window pane size
vim.keymap.set('n', '+', ':vertical resize -15<CR>', {})
vim.keymap.set('n', '=', ':vertical resize +15<CR>', {})
vim.keymap.set('n', '-', ':resize +5<CR>', {})
vim.keymap.set('n', '_', ':resize -5<CR>', {})

-- copy path to file from CWD
vim.keymap.set('n', 'cp', ':let @+ = expand("%")<CR>', { desc='copy path to file from CWD' })
-- copy current relative file path
vim.keymap.set('n', 'crp', ':let @+ = expand("%:~")<CR>', { desc='copy current relative file path' })
-- copy current file name
vim.keymap.set('n', 'cn', ':let @+ = expand("%:t")<CR>', { desc='copy current file name' })

-- open CHADTree
vim.keymap.set('n', '<Leader>v', '<cmd>CHADopen<CR>', {})
