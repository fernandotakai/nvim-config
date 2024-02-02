-- vim options {{{

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

vim.opt.lazyredraw=true

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.clipboard = 'unnamed'

-- disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- end vim options }}}

-- remapping options {{{

local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- useless mappings
keymap('n', 'K', '<nop>', opts)
keymap('n', 'J', '<nop>', opts)

keymap('n', '<Up>', '<nop>', opts)
keymap('n', '<Down>', '<nop>', opts)

-- command line mode
keymap('n', 'q:', '<nop>', opts)

-- indent/de-indent using keys on normal/visual mode
keymap('n', '<Left>', '<<', opts)
keymap('v', '<Left>', '<gv', opts)
keymap('n', '<Right>', '>>', opts)
keymap('v', '<Right>', '>gv', opts)

-- split current file
keymap('n', '<leader>bv', ':botright vsplit<cr>', opts)
keymap('n', '<leader>bs', ':botright split<cr>', opts)

-- end remapping }}}

-- autocmds {{{

-- try to open neovim on the last known position
vim.api.nvim_create_autocmd('BufReadPost', {
  callback = function(args)
    local valid_line = vim.fn.line([['"]]) >= 1 and vim.fn.line([['"]]) < vim.fn.line('$')
    local not_commit = vim.b[args.buf].filetype ~= 'commit'

    if valid_line and not_commit then
      vim.cmd([[normal! g`"]])
    end
  end,
})

-- end autocmds }}}

-- lazy setup {{{
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
  'tpope/vim-fugitive',
  'tpope/vim-surround',
  'tpope/vim-sleuth',

  'preservim/nerdcommenter',

  {
    'sainnhe/sonokai',
    lazy = false,
    priority = 1000,
    config = function ()
      vim.cmd([[ colorscheme sonokai ]])
    end,
  }, --sonokai

  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {
      options = {
        theme = 'horizon',
      }
    }
  }, -- lualine

  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
      }
    }
  }, -- telescope

  {
    'akinsho/bufferline.nvim',
    version = '*',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
  }, -- bufferline
  
  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = { 'nvim-tree/nvim-web-devicons' },
  },
}

local opts = {}

require('lazy').setup(plugins, opts)

-- end lazy setup }}}

-- telescope config {{{
local telescope = require('telescope')
local telescope_actions = require('telescope.actions')
local telescope_builtin = require('telescope.builtin')

telescope.setup {
  defaults = {
    dynamic_preview_title = true,
    mappings = {
      i = {
        ["<esc>"] = telescope_actions.close,
        ["<C-s>"] = telescope_actions.select_horizontal
      },
    },
  },
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = "smart_case",
    }
  }
}

telescope.load_extension("fzf")

vim.keymap.set('n', '<leader>p', telescope_builtin.find_files, {})
vim.keymap.set('n', '<leader>q', telescope_builtin.buffers, {})
vim.keymap.set('n', '<leader>g', telescope_builtin.live_grep, {})
vim.keymap.set('n', '<leader>[', telescope_builtin.tags, {})
vim.keymap.set('n', '<leader>?', telescope_builtin.oldfiles, {})

-- end telescope }}}

-- bufferline config {{{

bufferline = require('bufferline')
bufferline.setup{
  options = {
    numbers = "ordinal",
    offsets = {
      {
        filetype = "NvimTree",
        text = function()
          return vim.fn.getcwd()
        end,
        highlight = "Directory",
        text_align = "left"
      }
    }
  }
}

for i = 1, 9 do
  vim.keymap.set('n', '<leader>' .. i, function() bufferline.go_to(i, true) end, {})
end

vim.keymap.set('n', '<leader>0', function() bufferline.go_to(-1, true) end, {})

vim.keymap.set('n', '[b', function() bufferline.move_to(1) end, {})
vim.keymap.set('n', ']b', function() bufferline.go_to(-1) end, {})

keymap('n', '<leader>d', ':bd<cr>', {})

-- end bufferline }}}

-- nvimtree config {{{

local nvim_tree_api = require("nvim-tree.api")

local function edit_or_open()
  local node = nvim_tree_api.tree.get_node_under_cursor()

  if node.nodes ~= nil then
    -- expand or collapse folder
    nvim_tree_api.node.open.edit()
  else
    -- open file
    nvim_tree_api.node.open.edit()
    -- Close the tree if file was opened
    nvim_tree_api.tree.close()
  end
end

-- open as vsplit on current node
local function vsplit_preview()
  local node = nvim_tree_api.tree.get_node_under_cursor()

  if node.nodes ~= nil then
    -- expand or collapse folder
    nvim_tree_api.node.open.edit()
  else
    -- open file as vsplit
    nvim_tree_api.node.open.vertical()
  end

  -- Finally refocus on tree if it was lost
  nvim_tree_api.tree.focus()
end

local function nvim_tree_on_attach(bufnum)
  vim.keymap.set("n", "l", edit_or_open)
  vim.keymap.set("n", "L", vsplit_preview)
  vim.keymap.set("n", "h", nvim_tree_api.tree.close)
  vim.keymap.set("n", "H", nvim_tree_api.tree.collapse_all)
end

vim.api.nvim_set_keymap("n", "<C-h>", ":NvimTreeToggle<cr>", {silent = true, noremap = true})

require("nvim-tree").setup({
  on_attach = nvim_tree_on_attach,
  view = {
    width = 50,
  },
})

-- end nvimtree }}}

-- vim: ts=2 sts=2 sw=2 et foldmethod=marker foldlevel=0
