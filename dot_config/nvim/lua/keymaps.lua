local wk = require('which-key')

-- Custom keymaps
--- Get out without Esc
vim.keymap.set({ 'i' }, 'jk', '<Esc>', { desc = 'Escape back to normal mode' })
vim.keymap.set('t', 'jk', '<C-\\><C-n>', { desc = 'Escape back to normal mode' })

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
wk.register({
    c = {
        p = { ':let @+ = expand("%")<CR>', 'copy path to file from CWD' },
        -- copy current relative file path
        ['rp'] = { ':let @+ = expand("%:~")<CR>', 'copy current relative file path' },
        -- copy current file name
        n = { ':let @+ = expand("%:t")<CR>', 'copy current file name' },
    }
})

wk.register({
    -- toggle wordwrap
    ['<leader>ww'] = { ':set wrap!<CR>', 'Toggle Word Wrap' },
    -- toggle column highlighting
    ['<leader>cc'] = { function()
        if (vim.g.colorcolumntoggle == true)
        then
            vim.opt.colorcolumn = {}
            vim.g.colorcolumntoggle = false
        else
            vim.opt.colorcolumn = { '80', '120' }
            vim.g.colorcolumntoggle = true
        end
    end
        , 'Toggle Color Column' },
    ['<leader>mm'] = { ':MarkdownPreview<CR>', 'Markdown Preview' }
})

-- open CHADTree
vim.keymap.set('n', '<Leader>v', '<cmd>CHADopen<CR>', {})

-- Telescope keymaps
local builtin = require('telescope.builtin')
wk.register({
    ['<leader>f'] = {
        name = "Telescope Commands",
        a = { builtin.builtin, 'Find Built-in Telescope Pickers' },
        d = {
            function() require('telescope').extensions.file_browser.file_browser({ path = '%:p:h' }) end,
            'Find in File Browser (Current File)'
        },
        D = { require('telescope').extensions.file_browser.file_browser, 'Find in File Browser (cwd)' },
        f = { builtin.find_files, 'Find Files' },
        g = { builtin.live_grep, 'Find Live Grep' },
        b = { builtin.buffers, 'Find in Buffers' },
        j = { builtin.jumplist, 'Find in Jump List Entries' },
        h = { builtin.help_tags, 'Find in Help Tags' },
        k = { builtin.keymaps, 'Find in Keymaps' },
        r = { builtin.registers, 'Find in Registers' },
        l = {
            name = "Find in LSP",
            r = { builtin.lsp_references, 'Find LSP References' },
            d = { builtin.lsp_definitions, 'Find LSP Definitions' },
        }
    }
})

-- nvim-dap keymaps
wk.register({
    ['<leader>d'] = {
        name = 'Debug Commands',
        c = { [[:lua require'dap'.continue()<CR>]], 'DAP: Continue or Start' },
        o = { [[:lua require'dap'.step_over()<CR>]], 'DAP: Step Over' },
        i = { [[:lua require'dap'.step_into()<CR>]], 'DAP: Step Into' },
        u = { [[:lua require'dap'.set_out()<CR>]], 'DAP: Step Out' },
        b = { [[:lua require'dap'.toggle_breakpoint()<CR>]], 'DAP: Toggle Breakpoint' },
        B = { [[:lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>]],
            'DAP: Set Breakpoint With Condition' },
        s = { [[:lua require'dap'.terminate()<CR>]], 'DAP: Stop (Terminate)' },
        m = { function()
            if vim.bo.filetype == 'python' then
                require 'dap-python'.test_method()
            else
                print('Invalid filetype for command')
            end
        end, 'DAP: Test Method (filetype dependent)'
        },
        v = { [[:lua require'dapui'.toggle()<CR>]], 'DAP UI: Toggle UI' }
    }
})

-- neotest keymaps
wk.register({
    ['<leader>t'] = {
        name = 'Testing Commands',
        t = { [[:lua require'neotest'.run.run()<CR>]], 'Neotest: Run Nearest Test' },
        f = { [[:lua require'neotest'.run.run(vim.fn.expand('%'))<CR>]], 'Neotest: Run Current File' },
        d = { [[:lua require'neotest'.run.run({strategy = 'dap'})<CR>]], 'Neotest: Debug Nearest Test' },
        s = { [[:lua require'neotest'.run.stop()<CR>]], 'Neotest: Stop Nearest Test' },
        vs = { [[:lua require'neotest'.summary.toggle()<CR>]], 'Neotest: Toggle Summary Pane' },
        vo = { [[:lua require'neotest'.output.open()<CR>]], 'Neotest: Open Output Popout' },
        vO = { [[:lua require'neotest'.output_panel.toggle()<CR>]], 'Neotest: Toggle Output Panel' }
    }
})
