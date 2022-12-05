-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

plugs = require('plugins')
-- require('packer').compile()
require('options')
require('keymaps')
require('themes')

-- Sets up COQ with nvim-lspconfig configs.
-- Must be done after nvim-lspconfig
vim.g.coq_settings = { auto_start = 'shut-up' }

local coq = require('coq')
local lspconfig = require('lspconfig')


local language_servers = {
  'sumneko_lua',
  'pyright',
  'jsonls',
  'marksman',
  'sqlls',
  'taplo',
  'yamlls'
}

for _, lsp in ipairs(language_servers) do
  lspconfig[lsp].setup(coq.lsp_ensure_capabilities({}))
end