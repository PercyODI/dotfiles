local wk = require('which-key')

-- Custom keymaps
--- Get out without Esc
vim.keymap.set({'i'}, 'jk', '<Esc>', { desc = 'Escape back to normal mode' })
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

-- Telescope keymaps
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

-- nvim-dap keymaps
wk.register({
	['<leader>d'] = {
		name = 'Debug Commands',
		c = {[[:lua require'dap'.continue()<CR>]], 'DAP: Continue or Start'},
		o = {[[:lua require'dap'.step_over()<CR>]], 'DAP: Step Over'},
		i = {[[:lua require'dap'.step_into()<CR>]], 'DAP: Step Into'},
		u = {[[:lua require'dap'.set_out()<CR>]], 'DAP: Step Out'},
		b = {[[:lua require'dap'.toggle_breakpoint()<CR>]], 'DAP: Toggle Breakpoint'},
		B = {[[:lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>]], 'DAP: Set Breakpoint With Condition'},
		m = { function()
					if vim.bo.filetype == 'python' then
						require'dap-python'.test_method()
					else
						print('Invalid filetype for command')
					end
				end, 'DAP: Test Method (filetype dependent)'
			},
		v = {[[:lua require'dapui'.toggle()<CR>]], 'DAP UI: Toggle UI'}
	}
})
-- vim.keymap.set('n', [[<leader>dc]], [[:lua require'dap'.continue()<CR>]], { desc='DAP: Continue or Start' })
-- vim.keymap.set('n', [[<leader>do]], [[:lua require'dap'.step_over()<CR>]], { desc='DAP: Step Over' })
-- vim.keymap.set('n', [[<leader>di]], [[:lua require'dap'.step_into()<CR>]], { desc='DAP: Step Into' })
-- vim.keymap.set('n', [[<leader>du]], [[:lua require'dap'.set_out()<CR>]], { desc='DAP: Step Out' })
-- vim.keymap.set('n', [[<leader>db]], [[:lua require'dap'.toggle_breakpoint()<CR>]], { desc='DAP: Toggle Breakpoint' })
-- vim.keymap.set('n', [[<leader>dB]], [[:lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>]], { desc='DAP: Set Breakpoint With Condition' })
-- 
-- -- nvim-dap-python keymaps
-- vim.keymap.set('n', [[<leader>dm]], function()
-- 		if vim.bo.filetype == 'python' then
-- 			vim.cmd([[:lua require'dap-python'.test_method()<CR>]])
-- 		else
-- 			print('Invalid filetype for command')
-- 		end
-- 	end, { desc = 'DAP: Test Method (filetype dependent)' })
