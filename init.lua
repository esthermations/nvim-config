-- esther's vim config... in lua.

-- To paste stuff in here in neovide, type "+p in normal mode.

-- cd to home on startup...
vim.api.nvim_command('autocmd VimEnter * cd ~')

local o  = vim.o
local wo = vim.wo

vim.cmd 'colorscheme rose-pine'
o.background  = 'light'
o.guifont = "JetBrains Mono:10"

o.expandtab  = true -- Spaces not tabs
o.joinspaces = true -- No double-spaces from Shift+J
o.smartcase  = true
o.shiftwidth = 3

o.termguicolors = true

o.scrolloff = 2
o.hlsearch  = true
o.incsearch = true

o.updatetime  = 250
o.completeopt = 'menuone,noselect'

wo.number = true
wo.relativenumber = true

vim.api.nvim_set_keymap('', '<Space>', '<Nop>', { noremap = true, silent = true })
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Neovide
vim.g.neovide_cursor_vfx_mode = "wireframe"
vim.g.neovide_refresh_rate    = 100

--
-- Packages
--

vim.cmd [[packadd packer.nvim]]

require('packer').startup(function()
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
end)


require('feline').setup({ preset = 'noicon' })
--require('statusline')

require('telescope').setup { extensions = { fzf = {} } }
require('telescope').load_extension('fzf')


vim.api.nvim_set_keymap('n', '<leader><space>', [[<cmd>lua require('telescope.builtin').buffers()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>sf', [[<cmd>lua require('telescope.builtin').find_files({previewer = false})<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>sb', [[<cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>sh', [[<cmd>lua require('telescope.builtin').help_tags()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>st', [[<cmd>lua require('telescope.builtin').tags()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>sd', [[<cmd>lua require('telescope.builtin').grep_string()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>sp', [[<cmd>lua require('telescope.builtin').live_grep()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>so', [[<cmd>lua require('telescope.builtin').tags{ only_current_buffer = true }<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>?', [[<cmd>lua require('telescope.builtin').oldfiles()<CR>]], { noremap = true, silent = true })

require('nvim-treesitter.configs').setup {
   highlight = { enable = true },
   indent    = { enable = true },
}

local lspconfig = require('lspconfig')
local on_attach = function(_, bufnr)
  local opts = { noremap = true, silent = true }
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>so', [[<cmd>lua require('telescope.builtin').lsp_document_symbols()<CR>]], opts)
  vim.cmd [[ command! Format execute 'lua vim.lsp.buf.formatting()' ]]
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

local lspServers = { 'clangd' } 

for _, lsp in ipairs(lspServers) do
   lspconfig[lsp].setup {
      on_attach = on_attach,
      capabilities = capabilities
   }
end

-- TODO build ada_language_server which requires libadalang which requires
-- xmlada which fails to build on Windows due to a syntax
-- error in a generated config.status file

--lsp.als.setup({ cmd = "C:/Users/Esther O'Keefe/Bin/als.exe" })
 

-- vim: ts=3 sts=3 sw=3 et
