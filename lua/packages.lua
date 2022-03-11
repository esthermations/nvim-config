------------------------------------------------------------------------------
-- Packages
--
-- It's useful to have this in its own file so that all packages are loaded
-- before anything else in init.lua happens. That way we can set the colour
-- scheme or etc without the whole startup procedure exploding.
------------------------------------------------------------------------------

vim.cmd('packadd packer.nvim')
local packer = require('packer')

return packer.startup(function()
   use 'wbthomason/packer.nvim'
   use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
   use 'neovim/nvim-lspconfig'
   use 'folke/which-key.nvim'
   use 'feline-nvim/feline.nvim'

   use 'NLKNguyen/papercolor-theme'
   use { 'rose-pine/neovim', as = 'rose-pine' }

   use { 'nvim-telescope/telescope.nvim', requires = { 'nvim-lua/plenary.nvim' } }
   use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'c:/msys2/usr/bin/make.exe' }

   use 'hrsh7th/nvim-cmp'
   use 'hrsh7th/cmp-nvim-lsp'
   use 'numToStr/Comment.nvim' -- 'gc' on visual area to comment it out
   use 'rcarriga/nvim-notify'

   use 'nvim-orgmode/orgmode'
end)
