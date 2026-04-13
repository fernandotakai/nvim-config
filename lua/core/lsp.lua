-- LSP language configuration functions {{{

local blink = require("blink.cmp")

vim.lsp.config('lua_ls', {
  settings = {
    Lua = {
      runtime = { version = 'LuaJIT' },
      diagnostics = { globals = { 'vim' } },
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME,
        },
      },
      telemetry = { enable = false },
    },
  },
  capabilities = vim.tbl_deep_extend(
    "force",
    {},
    vim.lsp.protocol.make_client_capabilities(),
    blink.get_lsp_capabilities(),
    {
      fileOperations = {
        didRename = true,
        willRename = true,
      },
    }
  ),
})


vim.lsp.config('basedpyright', {
  settings = {
    basedpyright = {
      disableOrganizeImports = true,
      analysis = {
        typeCheckingMode = "off",
      }
    },
    python = {
      analysis = {
        ignore = { '*' },
      }
    },
  }
})

vim.lsp.config('vtsls', {})
vim.lsp.config('rust-analyzer', {})

-- End LSP language configuration }}}

vim.lsp.enable({
  'lua_ls',
  'basedpyright',
  'ruff',
  'vtsls',
  'rust-analyzer',
})


-- LSP Attach functions {{{

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local bufnr = args.buf
    local map = function(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
    end

    map('n', 'K', vim.lsp.buf.hover, 'LSP Hover')
    map('n', 'gD', vim.lsp.buf.declaration, 'Go to declaration')

    -- all these are being setup inside lua/plugins/telescope.lua
    -- map('n', 'gr', vim.lsp.buf.references, 'References')
    -- map('n', 'gd', vim.lsp.buf.definition, 'Go to definition')
    -- map('n', 'gi', vim.lsp.buf.implementation, 'Go to implementation')

    map('n', '<leader>rn', vim.lsp.buf.rename, 'Rename symbol')
    map({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, 'Code action')
    vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
      vim.lsp.buf.format { async = true }
    end, { desc = 'Format current buffer with LSP' })
  end,
  desc = "LSP: Common configuration"
})

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup('lsp_attach_disable_ruff_hover', { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client == nil then
      return
    end
    if client.name == 'ruff' then
      -- Disable hover in favor of Pyright
      client.server_capabilities.hoverProvider = false
    end
  end,
  desc = 'LSP: Disable hover capability from Ruff',
})

-- end LSP Attach functions }}}

vim.diagnostic.config({
  severity_sort = true,
  update_in_insert = false,
  float = {
    border = 'rounded',
    source = 'if_many',
  },
  underline = true,
  virtual_text = {
    spacing = 2,
    source = 'if_many',
    prefix = '●',
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = 'E',
      [vim.diagnostic.severity.WARN] = 'W',
      [vim.diagnostic.severity.INFO] = 'I',
      [vim.diagnostic.severity.HINT] = 'H',
    },
  },
})
