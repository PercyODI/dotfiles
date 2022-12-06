local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
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
        indent = { enable = false}
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

  -- File Explorer
  use { 'ms-jpq/chadtree', run = 'python3 -m chadtree deps', branch = 'chad' }


  -- Which Key for viewing command possibilities
  use {
    'folke/which-key.nvim',
    config = function()
      require('which-key').setup {}
    end
  }

  -- Better command line and displaying nvim messages
  use({
    "folke/noice.nvim",
    config = function()
      require("noice").setup({
          -- add any options here
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

  -- Onedark Theme
  use 'navarasu/onedark.nvim'

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end)


