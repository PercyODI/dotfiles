local M = {}

-- Borrowed from https://github.com/wbthomason/dotfiles/blob/9134e87b00102cda07f875805f900775244067fe/neovim/.config/nvim/lua/config/utils.lua#L10-L17
---@param group string augroup
---@param cmds string|table autocmd
---@param clear boolean clear augroup
M.autocmd = function (group, cmds, clear)
  clear = clear == nil and false or clear
  if type(cmds) == 'string' then cmds = {cmds} end
  vim.cmd('augroup ' .. group)
  if clear then vim.cmd [[autocmd!]] end
  for _, c in ipairs(cmds) do vim.cmd('autocmd ' .. c) end
  vim.cmd [[augroup END]]
end

return M