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

vim.opt.lazyredraw = true

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.clipboard = 'unnamed'

vim.o.completeopt = 'menuone,noselect'

-- disable netrw
-- vim.g.loaded_netrw = 1
-- vim.g.loaded_netrwPlugin = 1

-- not sure if i like folds :/
-- vim.opt.foldmethod = "expr"
-- vim.opt.foldexpr = "nvim_treesitter#foldexpr()"

-- end vim options }}}

-- {{{ custom clipboard for orbstack
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
-- }}} end custom clipboard for orbstack

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

keymap('n', '<space>', 'za', opts)

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
    config = function()
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
      },
      'debugloop/telescope-undo.nvim',
    }
  }, -- telescope

  {
    'akinsho/bufferline.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
  }, -- bufferline

  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = { 'nvim-tree/nvim-web-devicons' },
  }, -- nvim-tree

  {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      { 'williamboman/mason.nvim', config = true },
      'williamboman/mason-lspconfig.nvim',

      -- Useful status updates for LSP
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      { 'j-hui/fidget.nvim',       opts = {} },

      -- Additional lua configuration, makes nvim stuff amazing!
      'folke/neodev.nvim',
    },
  }, -- nvim-lspconfig

  {
    -- Autocompletion
    'hrsh7th/nvim-cmp',
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',

      -- Adds LSP completion capabilities
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',

      -- Adds a number of user-friendly snippets
      'rafamadriz/friendly-snippets',
    },
  }, -- autocompletion

  {
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ':TSUpdate',
  }, -- treesitter

  {
    "LintaoAmons/scratch.nvim",
    event = "VeryLazy",
  }, -- scratch

  {
    "gbprod/yanky.nvim",
    opts = {}
  }, -- yanky

  {
    "shortcuts/no-neck-pain.nvim",
    version = '*',
  }, -- no neck pain

  {
    "tpope/vim-rhubarb",
    version = '*',
  }, -- rhubarb (for git browse)
}

local lazy_opts = {}

require('lazy').setup(plugins, lazy_opts)

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
telescope.load_extension("undo")

vim.keymap.set('n', '<leader>p', telescope_builtin.find_files, {})
vim.keymap.set('n', '<leader>q', telescope_builtin.buffers, {})
vim.keymap.set('n', '<leader>g', telescope_builtin.live_grep, {})
vim.keymap.set('n', '<leader>[', telescope_builtin.treesitter, {})
vim.keymap.set('n', '<leader>?', telescope_builtin.oldfiles, {})

vim.keymap.set('n', '<leader>G', telescope.extensions.undo.undo, {})

vim.keymap.set('n', '<leader>y', telescope.extensions.yank_history.yank_history, {})

-- end telescope }}}

-- bufferline config {{{

local bufferline = require('bufferline')
bufferline.setup {
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

keymap('n', '<leader>x', ':bd<cr>', {})

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

-- currently conflicting with... stuff?
-- open as vsplit on current node
--local function vsplit_preview()
--local node = nvim_tree_api.tree.get_node_under_cursor()

--if node.nodes ~= nil then
---- expand or collapse folder
--nvim_tree_api.node.open.edit()
--else
---- open file as vsplit
--nvim_tree_api.node.open.vertical()
--end

---- Finally refocus on tree if it was lost
--nvim_tree_api.tree.focus()
--end

--local function nvim_tree_on_attach(_)
--vim.keymap.set("n", "l", edit_or_open)
--vim.keymap.set("n", "L", vsplit_preview)
--vim.keymap.set("n", "h", nvim_tree_api.tree.close)
--vim.keymap.set("n", "H", nvim_tree_api.tree.collapse_all)
--end

vim.api.nvim_set_keymap("n", "<C-h>", ":NvimTreeToggle<cr>", { silent = true, noremap = true })

require("nvim-tree").setup({
  -- on_attach = nvim_tree_on_attach,
  view = {
    width = 50,
  },
})

-- end nvimtree }}}

-- treesitter config {{{

vim.defer_fn(function()
  require('nvim-treesitter.configs').setup {
    -- Add languages to be installed here that you want installed for treesitter
    ensure_installed = { 'python', 'javascript', 'typescript', 'tsx', 'lua', 'bash', 'json', 'vim' },

    -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
    auto_install = false,
    -- Install languages synchronously (only applied to `ensure_installed`)
    sync_install = false,
    -- List of parsers to ignore installing
    ignore_install = {},
    -- You can specify additional Treesitter modules here: -- For example: -- playground = {--enable = true,-- },
    modules = {},
    highlight = { enable = true },
    indent = { enable = true },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "gnn",
        node_incremental = "grn",
        scope_incremental = "grc",
        node_decremental = "grm",
      },
    },
  }
end, 0)

local on_attach = function(_, bufnr)
  -- NOTE: Remember that lua is a real programming language, and as such it is possible
  -- to define small helper and utility functions so you don't have to repeat yourself
  -- many times.
  --
  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

  nmap('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
  nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  nmap('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
  nmap('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
  nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
  nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

  -- See `:help K` for why this keymap
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

  -- Lesser used LSP functionality
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  nmap('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders')

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format { async = true }
  end, { desc = 'Format current buffer with LSP' })
end

-- mason-lspconfig requires that these setup functions are called in this order
-- before setting up the servers.
require('mason').setup()
require('mason-lspconfig').setup()

local servers = {
  -- clangd = {},
  -- gopls = {},
  -- pyright = {},
  -- rust_analyzer = {},
  -- tsserver = {},
  html = { filetypes = { 'html', 'twig', 'hbs' } },

  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
      -- NOTE: toggle below to ignore Lua_LS's noisy `missing-fields` warnings
      -- diagnostics = { disable = { 'missing-fields' } },
    },
  },

  ruff_lsp = {},
  tsserver = {},
  pylsp = {
    pylsp = {
      plugins = {
        ruff = { enabled = false },
        pylint = { enabled = false },
        flake8 = { enabled = false },
        pycodestyle = { enabled = false },
        pyflakes = { enabled = false },
        autopep8 = { enabled = false },
        yapf = { enabled = false },
      },
    }
  },
  jsonls = {},
  vimls = {},
}

require('neodev').setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
}

mason_lspconfig.setup_handlers {
  function(server_name)
    require('lspconfig')[server_name].setup {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = servers[server_name],
      filetypes = (servers[server_name] or {}).filetypes,
    }
  end,
}

-- end treesitter }}}

-- autocomplete config {{{

local cmp = require 'cmp'
local luasnip = require 'luasnip'
require('luasnip.loaders.from_vscode').lazy_load()
luasnip.config.setup {}

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  completion = {
    completeopt = 'menu,menuone,noinsert',
  },
  mapping = cmp.mapping.preset.insert {
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
    ['<C-Space>'] = cmp.mapping.complete {},
    ['<CR>'] = cmp.mapping.confirm {
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_locally_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.locally_jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  sources = {
    { name = 'nvim_lsp' },
    -- i don't like snippets :/
    { name = 'luasnip' },
    { name = 'path' },
  },
}

cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources({
    -- { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
  }, {})
})

cmp.setup.cmdline('/', {
  sources = {
    { name = 'buffer' }
  }
})

cmp.setup.cmdline(':', {
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})

-- end autocomplete }}}

-- scratch config {{{

vim.keymap.set("n", "<leader><tab>", "<cmd>Scratch<cr>")

-- end scratch }}}

-- yanky config {{{

vim.keymap.set({ "n", "x" }, "p", "<Plug>(YankyPutAfter)")
vim.keymap.set({ "n", "x" }, "P", "<Plug>(YankyPutBefore)")
vim.keymap.set({ "n", "x" }, "gp", "<Plug>(YankyGPutAfter)")
vim.keymap.set({ "n", "x" }, "gP", "<Plug>(YankyGPutBefore)")

require("telescope").load_extension("yank_history")

-- end yanky }}}

-- no neck pain config {{{

require("no-neck-pain").setup({
  width = 210
})


vim.keymap.set("n", "<leader>n", "<cmd>NoNeckPain<cr>")

-- end no neck pain }}}

-- vim: ts=2 sts=2 sw=2 et foldmethod=marker foldlevel=0
