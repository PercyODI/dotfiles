local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
        vim.cmd [[packadd packer.nvim]]
        return true
    end
    return false
end

local packer_bootstrap = ensure_packer()

return require('packer').startup(function(use)
    -- Packer manages itself
    use 'wbthomason/packer.nvim'

    -- Treesitter
    use { 'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate',
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
    }
    ---- Additional textobjects for treesitter
    use { 'nvim-treesitter/nvim-treesitter-textobjects',
        -- after = { 'nvim-treesitter' }
    }

    -- Manage external editor tooling i.e LSP servers
    use { 'williamboman/mason.nvim',
        config = function()
            require('mason').setup()
        end
    }
    ---- Automatically install language servers to stdpath
    use { 'williamboman/mason-lspconfig.nvim',
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
                    'yamlls'
                }
            }
        end
    }

    -- nvim lsp configurations
    use { 'neovim/nvim-lspconfig'
        -- , after = { 'mason-lspconfig.nvim' }
    }

    use { 'WhoIsSethDaniel/mason-tool-installer.nvim',
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
                    'yaml-language-server'
                },
                auto_update = true
            }
        end,
        after = 'mason-lspconfig.nvim'
    }

    use { 'jose-elias-alvarez/null-ls.nvim',
        config = function()
            local null_ls = require('null-ls')
            null_ls.setup {
                sources = {
                    null_ls.builtins.formatting.autopep8
                }
            }
        end
    }

    -- Debug Plugins
    use { 'mfussenegger/nvim-dap' }
    use { "rcarriga/nvim-dap-ui",
        requires = { "mfussenegger/nvim-dap" },
        config = function()
            require('dapui').setup()
        end
    }
    use { 'mfussenegger/nvim-dap-python',
        config = function()
            local dap_python = require('dap-python')
            dap_python.setup('~/.local/share/nvim/mason/packages/debugpy/venv/bin/python')
            dap_python.test_runner = 'pytest'
        end
    }

    -- Testing Plugins
    use {
      "nvim-neotest/neotest",
      requires = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
        "antoinemadec/FixCursorHold.nvim",
        "nvim-neotest/neotest-python"
      },
      config = function()
          require("neotest").setup {
              adapters = {
                  require("neotest-python")({
                      python = function()
                          local poetry_path = string.gsub(vim.fn.system("poetry env info --path"), '\n+', '') .. '/bin/python'
                          return poetry_path
                      end
                  })
              }
          }
      end
    }

    --  Autocompletion
    use {
        'ms-jpq/coq_nvim',
        -- after = { 'nvim-lspconfig' },
        branch = 'coq',
        run = ":COQdeps"
    }
    use { 'ms-jpq/coq.artifacts',
        branch = 'artifacts',
        -- after = { 'coq_nvim', 'nvim-lspconfig' },
        -- config = [[require('lang-server-config')]]
    }

    -- Comments with hotkeys
    use {
        'numToStr/Comment.nvim',
        config = function()
            require('Comment').setup()
        end
    }

    -- Toggle Terminal
    use {"akinsho/toggleterm.nvim",
        tag = '*',
        config = function()
            require("toggleterm").setup {
                open_mapping = [[<c-\>]]
            }
        end
    }

    -- Fuzzy Finder (files, lsp, etc)
    use { 'nvim-telescope/telescope.nvim',
        branch = '0.1.x',
        requires = { 'nvim-lua/plenary.nvim' },
        config = function()
            require('telescope').setup {

            }
        end
    }

    -- Fuzzy Finder Algorithm which requires local dependencies to be built. Only load if `make` is available
    use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make', cond = vim.fn.executable "make" == 1 }

    -- File Explorer
    use { 'ms-jpq/chadtree',
        run = 'python3 -m chadtree deps',
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
    }

    -- Git signs
    use { 'lewis6991/gitsigns.nvim',
        -- tag = 'release', -- To use the latest release (do not use this if you run Neovim nightly or dev builds!)
        config = function()
            require('gitsigns').setup {

            }
        end
    }

    -- Which Key for viewing command possibilities
    use {
        'folke/which-key.nvim',
        config = function()
            require('which-key').setup {
                show_keys = false,
                show_help = false
            }
        end
    }

    -- Better command line and displaying nvim messages
    use({
        "folke/noice.nvim",
        config = function()
            require("noice").setup({
                -- add any options here
                presets = {
                    long_message_to_split = true
                }
            })
        end,
        requires = {
            -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
            "MunifTanjim/nui.nvim",
            -- OPTIONAL:
            --   `nvim-notify` is only needed, if you want to use the notification view.
            --   If not available, we use `mini` as the fallback
            "rcarriga/nvim-notify",
        }
    })

    -- Auto Session management
    use {
        'rmagatti/auto-session',
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
    }

    -- Auto number toggling when switching buffers
    use {
        "sitiom/nvim-numbertoggle",
        config = function()
            require("numbertoggle").setup()
        end
    }

    -- Onedark Theme
    use 'navarasu/onedark.nvim'

    -- Better Statusline
    use { 'nvim-lualine/lualine.nvim',
        requires = { 'kyazdani42/nvim-web-devicons', opt = true },
        config = function()
            require('lualine').setup {
                extensions = { 'chadtree', 'nvim-dap-ui' }
            }
        end
    }

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if packer_bootstrap then
        require('packer').sync()
    end
end)
