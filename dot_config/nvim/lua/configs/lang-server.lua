print('Starting lang-server-config')

local lspconfig = require('lspconfig')

-- Sets up COQ with nvim-lspconfig configs.
-- Must be done after nvim-lspconfig
vim.g.coq_settings = { 
  auto_start = 'shut-up',
  display = {
    preview = {
      positions = {
		  north = 3,
		  south = 4,
		  west = nil,
		  east = nil
	  }
    },
    -- pum = {
    --   fast_close = false
    -- }
  },
  keymap = {
	jump_to_mark = ''
  }
}

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
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, { noremap=true, silent=true, desc='LSP: Diagnostic Open Float' })
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { noremap=true, silent=true, desc='LSP: Diagnostic Go To Previous' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { noremap=true, silent=true, desc='LSP: Diagnostic Go To Next' })
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, { noremap=true, silent=true, desc='LSP: Diagnostic SetLocList' })

-- Borrowed from https://github.com/neovim/nvim-lspconfig#suggested-configuration
-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = function(desc)
    return { noremap=true, silent=true, buffer=bufnr, desc=desc }
  end
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts("LSP: Go To Declaration"))
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts("LSP: Go To Definition"))
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts("LSP: Hover"))
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts("LSP: Go To Implementation"))
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts("LSP: Signature Help"))
  vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts("LSP: Add Workspace Folder"))
  vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts("LSP: Remove Workspace Folder"))
  vim.keymap.set('n', '<space>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts("LSP: List Workspace Folders"))
  vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts("LSP: Type Definition"))
  vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts("LSP: Rename"))
  vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts("LSP: Code Action"))
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts("LSP: Go To References"))
  vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, bufopts("LSP: Format"))


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

