-- esther's vim config... in lua.
-- To paste stuff in here in neovide, type "+p in normal mode.

-- Grab packages. This is done first for, y'know, dependency reasons.
require('packages')

-- cd to home on startup...
vim.api.nvim_command('autocmd VimEnter * cd ~')
vim.api.nvim_command('colorscheme PaperColor')

local o  = vim.o
local wo = vim.wo

o.background = 'light'
o.completeopt = 'menuone,noselect'
o.errorbells = false
o.expandtab  = true -- Spaces not tabs
o.guifont = 'JetBrains Mono:h12'
o.hlsearch = true
o.incsearch = true
o.joinspaces = true -- No double-spaces from Shift+J
o.scrolloff = 2
o.shiftwidth = 3
o.smartcase  = true
o.syntax = 'on'
o.termguicolors = true
o.updatetime = 250

wo.number = true
wo.relativenumber = true

-- Neovide
vim.g.neovide_cursor_vfx_mode = "wireframe"
vim.g.neovide_refresh_rate    = 100

------------------------------------------------------------------------------
-- Keymaps
------------------------------------------------------------------------------

local MapKey = function(Mode, Key, Result)
   vim.api.nvim_set_keymap(Mode, Key, Result, {noremap = true, silent = true})  
end

local KeysToUnmap = { '<space>', '<up>', '<down>', '<left>', '<right>' }

for _, Key in ipairs(KeysToUnmap) do
   MapKey('', Key, '<nop>')
end

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

MapKey('n', '<leader>b<tab>', ':bNext')
MapKey('n', '<leader>b<s-tab>', ':-1bNext')
MapKey('n', '<leader>wk', '<c-w>k')
MapKey('n', '<leader>wj', '<c-w>j')
MapKey('n', '<leader>wh', '<c-w>h')
MapKey('n', '<leader>wl', '<c-w>l')

MapKey('n', '<leader><space>', [[<cmd>lua require('telescope.builtin').buffers()<CR>]])
MapKey('n', '<leader>sf', [[<cmd>lua require('telescope.builtin').find_files({previewer = false})<CR>]])
MapKey('n', '<leader>sb', [[<cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<CR>]])
MapKey('n', '<leader>sh', [[<cmd>lua require('telescope.builtin').help_tags()<CR>]])
MapKey('n', '<leader>st', [[<cmd>lua require('telescope.builtin').tags()<CR>]])
MapKey('n', '<leader>sd', [[<cmd>lua require('telescope.builtin').grep_string()<CR>]])
MapKey('n', '<leader>sp', [[<cmd>lua require('telescope.builtin').live_grep()<CR>]])
MapKey('n', '<leader>so', [[<cmd>lua require('telescope.builtin').tags{ only_current_buffer = true }<CR>]])
MapKey('n', '<leader>?', [[<cmd>lua require('telescope.builtin').oldfiles()<CR>]])

require('orgmode').setup({})
require('feline').setup({})

require('telescope').setup({ extensions = { fzf = {} } })
require('telescope').load_extension('fzf')

require('orgmode').setup_ts_grammar()
require('nvim-treesitter.configs').setup {
   indent    = { enable = true },
   highlight = { 
      enable = true, 
      disable = {'org'},
      additional_vim_regex_highlighting = {'org'}
   },
   ensure_installed = {'org'}
}

require('orgmode').setup({
   org_default_notes_file = '%USERPROFILE%/Notes/Everything.org'
})

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
 
vim.notify = require("notify")

-- vim: ts=3 sts=3 sw=3 et
