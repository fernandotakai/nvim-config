vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.hlsearch = true
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.virtualedit = "all"

vim.opt.scrolloff = 5

vim.opt.undofile = true
vim.opt.undolevels = 50
vim.opt.undoreload = 50

vim.opt.lazyredraw = true

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.clipboard = 'unnamed'

vim.o.completeopt = 'menuone,noselect'

-- disable netrw
-- vim.g.loaded_netrw = 1
-- vim.g.loaded_netrwPlugin = 1

-- not sure if i like folds :/
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldlevel = 1

if vim.fn.has("macunix") == 0 and vim.fn.executable("pbcopy") == 1 then
  vim.g.clipboard = {
    name = 'OrbStack clipboard',
    copy = {
      ['+'] = 'pbcopy',
      ['*'] = 'pbcopy',
    },
    paste = {
      ['+'] = 'pbpaste',
      ['*'] = 'pbpaste',
    },
    cache_enabled = false,
  }
end

