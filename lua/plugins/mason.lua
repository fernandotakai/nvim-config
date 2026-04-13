return {
    {
        "mason-org/mason.nvim",
        opts = {}
    },
    {
        'neovim/nvim-lspconfig',
    },
    {
        'mason-org/mason-lspconfig.nvim',
        dependencies = {
            'mason-org/mason.nvim',
            'neovim/nvim-lspconfig',
        },
        opts = {},
        config = function()
            require('mason-lspconfig').setup({
                automatic_enable = false,
            })
        end
    },
    {
        'WhoIsSethDaniel/mason-tool-installer.nvim',
        dependencies = { 'mason-org/mason.nvim' },
        opts = {
            ensure_installed = {
                'lua_ls',
                'basedpyright',
                'python-lsp-server',
                'ruff',
                'vtsls',
            },
        },
    }
}
