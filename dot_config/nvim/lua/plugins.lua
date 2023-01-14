local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", lazypath })
    vim.fn.system({ "git", "-C", lazypath, "checkout", "tags/stable" }) -- last stable release
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    { 'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        config = function()
            require('nvim-treesitter.configs').setup {
                ensure_installed = {
                    'lua',
                    'python',
                    'json',
                    'markdown',
                    'sql',
                    'yaml',
                    'toml'
                },
                auto_install = true,
                highlight = {
                    enable = true
                },
                indent = { enable = false }
            }
        end
    },

    ---- Additional textobjects for treesitter
    { 'nvim-treesitter/nvim-treesitter-textobjects' },

    -- Manage external editor tooling i.e LSP servers
    { 'williamboman/mason.nvim',
        config = function()
            require('mason').setup()
        end
    },

    ---- Automatically install language servers to stdpath
    { 'williamboman/mason-lspconfig.nvim',
        -- after = { 'mason.nvim' },
        config = function()
            require('mason-lspconfig').setup {
                automatic_installation = true,
                ensure_installed = {
                    'sumneko_lua',
                    'pyright',
                    'jsonls',
                    'marksman',
                    'sqlls',
                    'taplo',
                    'yamlls',
                }
            }
        end
    },

    { 'WhoIsSethDaniel/mason-tool-installer.nvim',
        config = function()
            require('mason-tool-installer').setup {
                ensure_installed = {
                    'debugpy',
                    'lua-language-server',
                    'pyright',
                    'autopep8',
                    'json-lsp',
                    'marksman',
                    'sqlls',
                    'taplo',
                    'yaml-language-server',
                    -- 'misspell'
                },
                auto_update = true
            }
        end,
        -- after = 'mason-lspconfig.nvim'
    },

    -- nvim lsp configurations
    { 'neovim/nvim-lspconfig',
        -- config = function()
        --     require("config.lsp").setup()
        -- end,
        -- , after = { 'mason-lspconfig.nvim' }
    },


    { 'jose-elias-alvarez/null-ls.nvim',
        config = function()
            local null_ls = require('null-ls')
            null_ls.setup {
                sources = {
                    null_ls.builtins.formatting.autopep8,
                    -- null_ls.builtins.diagnostics.misspell,
                    -- null_ls.builtins.completion.spell,
                }
            }
        end
    },

    -- Debug Plugins
    { 'mfussenegger/nvim-dap' },
    { "rcarriga/nvim-dap-ui",
        requires = { "mfussenegger/nvim-dap" },
        config = function()
            require('dapui').setup()

            -- Automatically open DAP UI when DAP is active
            local dap, dapui = require('dap'), require('dapui')
            dap.listeners.after.event_initialized['dapui_config'] = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated['dapui_config'] = function()
                dapui.close()
            end
            dap.listeners.before.event_exited['dapui_config'] = function()
                dapui.close()
            end
        end
    },
    { 'mfussenegger/nvim-dap-python',
        config = function()
            local dap_python = require('dap-python')
            dap_python.setup('~/.local/share/nvim/mason/packages/debugpy/venv/bin/python')
            dap_python.test_runner = 'pytest'
        end
    },

    -- Testing Plugins
    {
        "nvim-neotest/neotest",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
            "antoinemadec/FixCursorHold.nvim",
            "nvim-neotest/neotest-python"
        },
        config = function()
            require("neotest").setup {
                adapters = {
                    require("neotest-python")({
                        -- python = function()
                        --     local poetry_path = string.gsub(vim.fn.system("poetry env info --path"), '\n+', '') ..
                        --         '/bin/python'
                        --     return poetry_path
                        -- end
                    })
                }
            }
        end
    },

    --  Autocompletion
    {
        'ms-jpq/coq_nvim',
        -- after = { 'nvim-lspconfig' },
        branch = 'coq',
        enabled = false,
        build = ":COQdeps",
        init = function()
            vim.g.coq_settings = {
                auto_start = 'shut-up',
                display = {
                    preview = {
                        positions = {
                            north = 1,
                            south = 2,
                            west = nil,
                            east = 3
                        }
                    },
                    pum = {
                        fast_close = false
                    }
                },
                keymap = {
                    jump_to_mark = ''
                }
            }
        end,
        config = function()
            print('Starting lang-server-config')

            local lspconfig = require('lspconfig')

            -- Sets up COQ with nvim-lspconfig configs.
            -- Must be done after nvim-lspconfig

            local coq = require('coq')

            local language_servers = {
                'sumneko_lua',
                'pyright',
                'jsonls',
                'marksman',
                'sqlls',
                'taplo',
                'yamlls'
            }

            -- Mappings.
            -- See `:help vim.diagnostic.*` for documentation on any of the below functions
            vim.keymap.set('n', '<space>e', vim.diagnostic.open_float,
                { noremap = true, silent = true, desc = 'LSP: Diagnostic Open Float' })
            vim.keymap.set('n', '[d', vim.diagnostic.goto_prev,
                { noremap = true, silent = true, desc = 'LSP: Diagnostic Go To Previous' })
            vim.keymap.set('n', ']d', vim.diagnostic.goto_next,
                { noremap = true, silent = true, desc = 'LSP: Diagnostic Go To Next' })
            vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist,
                { noremap = true, silent = true, desc = 'LSP: Diagnostic SetLocList' })

            -- Borrowed from https://github.com/neovim/nvim-lspconfig#suggested-configuration
            -- Use an on_attach function to only map the following keys
            -- after the language server attaches to the current buffer
            local on_attach = function(client, bufnr)
                -- Enable completion triggered by <c-x><c-o>
                -- vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

                -- Mappings.
                -- See `:help vim.lsp.*` for documentation on any of the below functions
                local bufopts = function(desc)
                    return { noremap = true, silent = true, buffer = bufnr, desc = desc }
                end
                vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts("LSP: Go To Declaration"))
                vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts("LSP: Go To Definition"))
                vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts("LSP: Hover"))
                vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts("LSP: Go To Implementation"))
                vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts("LSP: Signature Help"))
                vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts("LSP: Add Workspace Folder"))
                vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder,
                    bufopts("LSP: Remove Workspace Folder"))
                vim.keymap.set('n', '<space>wl', function()
                    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                end, bufopts("LSP: List Workspace Folders"))
                vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts("LSP: Type Definition"))
                vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts("LSP: Rename"))
                vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts("LSP: Code Action"))
                vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts("LSP: Go To References"))
                vim.keymap.set('n', '<space>F', function() vim.lsp.buf.format { async = true } end,
                    bufopts("LSP: Format"))


            end

            -- local lsp_flags = {
            --   -- This is the default in Nvim 0.7+
            --   debounce_text_changes = 150,
            -- }

            for _, lsp in ipairs(language_servers) do
                lspconfig[lsp].setup(coq.lsp_ensure_capabilities({
                    on_attach = on_attach,
                    -- flags = lsp_flags
                }))
            end

        end
    },

    { 'ms-jpq/coq.artifacts',
        branch = 'artifacts',
        enabled = false,
        -- after = { 'coq_nvim', 'nvim-lspconfig' },
        -- config = [[require('lang-server-config')]]
    },

    { 'ms-jpq/coq.thirdparty',
        enabled = false
    },

    { 'hrsh7th/nvim-cmp',
        dependencies = {
            'hrsh7th/cmp-nvim-lsp',
            'L3MON4D3/LuaSnip',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-cmdline',
            'f3fora/cmp-spell',
        },
        enabled = true,
        config = function()
            -- Add additional capabilities supported by nvim-cmp
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            local lspconfig = require('lspconfig')

            -- Enable some language servers with the additional completion capabilities offered by nvim-cmp
            local servers = { ['clangd'] = {},
                ['rust_analyzer'] = {},
                ['pyright'] = {},
                ['tsserver'] = {},
                ['sumneko_lua'] = {}, }

            -- Mappings.
            -- See `:help vim.diagnostic.*` for documentation on any of the below functions
            vim.keymap.set('n', '<space>e', vim.diagnostic.open_float,
                { noremap = true, silent = true, desc = 'LSP: Diagnostic Open Float' })
            vim.keymap.set('n', '[d', vim.diagnostic.goto_prev,
                { noremap = true, silent = true, desc = 'LSP: Diagnostic Go To Previous' })
            vim.keymap.set('n', ']d', vim.diagnostic.goto_next,
                { noremap = true, silent = true, desc = 'LSP: Diagnostic Go To Next' })
            vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist,
                { noremap = true, silent = true, desc = 'LSP: Diagnostic SetLocList' })

            -- Borrowed from https://github.com/neovim/nvim-lspconfig#suggested-configuration
            -- Use an on_attach function to only map the following keys
            -- after the language server attaches to the current buffer
            local on_attach = function(client, bufnr)
                -- Enable completion triggered by <c-x><c-o>
                -- vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

                -- Mappings.
                -- See `:help vim.lsp.*` for documentation on any of the below functions
                local bufopts = function(desc)
                    return { noremap = true, silent = true, buffer = bufnr, desc = desc }
                end
                vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts("LSP: Go To Declaration"))
                vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts("LSP: Go To Definition"))
                vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts("LSP: Hover"))
                vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts("LSP: Go To Implementation"))
                vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts("LSP: Signature Help"))
                vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts("LSP: Add Workspace Folder"))
                vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder,
                    bufopts("LSP: Remove Workspace Folder"))
                vim.keymap.set('n', '<space>wl', function()
                    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                end, bufopts("LSP: List Workspace Folders"))
                vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts("LSP: Type Definition"))
                vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts("LSP: Rename"))
                vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts("LSP: Code Action"))
                vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts("LSP: Go To References"))
                vim.keymap.set('n', '<space>F', function() vim.lsp.buf.format { async = true } end,
                    bufopts("LSP: Format"))
            end
            for lsp, settings in pairs(servers) do
                lspconfig[lsp].setup {
                    on_attach = on_attach,
                    capabilities = capabilities,
                    settings = settings
                }
            end

            -- luasnip setup
            local luasnip = require 'luasnip'

            -- nvim-cmp setup
            local cmp = require 'cmp'
            cmp.setup {
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-f>'] = cmp.mapping.scroll_docs(4),
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<CR>'] = cmp.mapping.confirm {
                        behavior = cmp.ConfirmBehavior.Replace,
                        select = false, -- Don't auto select on Enter.
                    },
                    ['<Tab>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        else
                            fallback()
                        end
                    end, { 'i', 's' }),
                    ['<S-Tab>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { 'i', 's' }),
                }),
                sources = {
                    { name = 'nvim_lsp' },
                    { name = 'luasnip' },
                    { name = 'spell',
                        option = {
                            keep_all_entries = false,
                        },
                    },
                },
            }
        end
    },

    {
        'psliwka/vim-dirtytalk',
        build = function()
            print('Updating programming dictionary')
            vim.cmd('DirtytalkUpdate')
        end
    },

    -- Adding surround for quotes, brackets, etc
    {
        'kylechui/nvim-surround',
        config = function()
            require('nvim-surround').setup({})
        end
    },

    -- Adding Dadbod for database connections
    {
        'tpope/vim-dadbod'
    },

    {
        'kristijanhusak/vim-dadbod-ui'
    },

    -- Comments with hotkeys
    {
        'numToStr/Comment.nvim',
        config = function()
            require('Comment').setup()
        end
    },

    -- Toggle Terminal
    { "akinsho/toggleterm.nvim",
        config = function()
            require("toggleterm").setup {
                open_mapping = [[<c-\>]]
            }
        end
    },

    -- Fuzzy Finder (files, lsp, etc)
    { 'nvim-telescope/telescope.nvim',
        branch = '0.1.x',
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function()
            require('telescope').setup {

            }
        end
    },

    -- Fuzzy Finder Algorithm which requires local dependencies to be built. Only load if `make` is available
    { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make', cond = vim.fn.executable "make" == 1 },
    --
    -- File Explorer
    { 'ms-jpq/chadtree',
        build = 'python3 -m chadtree deps',
        branch = 'chad',
        config = function()
            local chadtree_settings = {
                view = {
                    window_options = {
                        relativenumber = true
                    }
                },
            }
            vim.api.nvim_set_var("chadtree_settings", chadtree_settings)
        end
    },

    -- Git signs
    { 'lewis6991/gitsigns.nvim',
        -- tag = 'release', -- To use the latest release (do not use this if you run Neovim nightly or dev builds!)
        config = function()
            require('gitsigns').setup {

            }
        end
    },

    -- Which Key for viewing command possibilities
    { 'folke/which-key.nvim',
        config = function()
            require('which-key').setup {
                show_keys = false,
                show_help = false
            }
        end
    },
    --
    -- Better command line and displaying nvim messages
    { "folke/noice.nvim",
        config = function()
            require("noice").setup({
                -- add any options here
                presets = {
                    long_message_to_split = true
                }
            })
        end,
        dependencies = {
            -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
            "MunifTanjim/nui.nvim",
            -- OPTIONAL:
            --   `nvim-notify` is only needed, if you want to use the notification view.
            --   If not available, we use `mini` as the fallback
            "rcarriga/nvim-notify",
        }
    },

    -- Auto Session management
    { 'rmagatti/auto-session',
        config = function()
            require("auto-session").setup {
                log_level = "error",
                auto_session_suppress_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
                auto_session_root_dir = os.getenv('HOME') .. '/.vim/sessions/',
                pre_save_cmds = {
                    function()
                        -- Close chadtree because it is a scratch buffer that doesn't preserve the tree
                        -- Note: There is no close function, so I have to open with always focus to
                        --       ensure it is open, then toggle it closed
                        --vim.cmd('CHADopen --always-focus')
                        --vim.cmd('CHADopen')
                        vim.api.nvim_exec(
                            [[
                                let l:bufs = filter(range(1, bufnr('$')), 'getbufvar(v:val, "&filetype") == "CHADTree"')
                                for l:buf in l:bufs
                                    :execute "bdelete " . l:buf
                                endfor
                            ]], true)

                        -- Close DAP UI because it can't be saved in the session safely
                        require('dapui').close()
                    end
                }
            }
        end
    },

    -- Auto number toggling when switching buffers
    { "sitiom/nvim-numbertoggle" },
    --
    -- Onedark Theme
    { 'navarasu/onedark.nvim' },
    --
    -- Better Statusline
    { 'nvim-lualine/lualine.nvim',
        dependencies = { 'kyazdani42/nvim-web-devicons' },
        config = function()
            require('lualine').setup {
                extensions = { 'chadtree', 'nvim-dap-ui' }
            }
        end
    },
})
