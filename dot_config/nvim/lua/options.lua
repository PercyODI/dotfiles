local autocmd = require 'utils'.autocmd

-- Make line numbers default
vim.wo.number = true
vim.wo.relativenumber = true

-- Save undo history
vim.opt.undofile = true
vim.opt.undodir = os.getenv('HOME') .. [[/.vim/undodir/]]

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Set the height of the command bar
vim.opt.cmdheight = 1

-- Turn off sound effects for errors
vim.opt.errorbells = false

-- Set tab and indent to 4 spaces
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- Highlight the current line
vim.opt.cursorline = true

-- Set nowrap as default
vim.wo.wrap = false
vim.wo.linebreak = true

-- Set an 80 and 120 column line for reference
vim.opt.colorcolumn = {80, 120}
vim.g.colorcolumntoggle = true

-- Check if file changed outside vim & re-read file
autocmd('focus_gain', [[FocusGained * silent! noautocmd checktime]], true)

-- Set completeopt for nvim-cmp
vim.opt.completeopt = {'menu', 'menuone', 'noselect'}

-- Set spellcheck to on
vim.opt.runtimepath:append('~/.local/share/nvim/site,')
vim.opt.spell = true
vim.opt.spelllang = { 'en_us', 'programming' }
