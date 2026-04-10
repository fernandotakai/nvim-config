return {
    'nvim-telescope/telescope.nvim',
    dependencies = {
        'nvim-lua/plenary.nvim',
        {
            'nvim-telescope/telescope-fzf-native.nvim',
            build = 'make',
        },
        'debugloop/telescope-undo.nvim',
        'Marskey/telescope-sg',
    },
    config = function ()
        local telescope_actions = require('telescope.actions')
        local telescope = require('telescope')

        telescope.setup({
            defaults = {
                dynamic_preview_title = true,
                mappings = {
                    i = {
                        ['<esc>'] = telescope_actions.close,
                        ['<C-s>'] = telescope_actions.select_horizontal
                    },
                },
            },
            extensions = {
                fzf = {
                    fuzzy = true,
                    override_generic_sorter = true,
                    override_file_sorter = true,
                    case_mode = 'smart_case',
                },
                ast_grep = {
                    command = {
                        'ast-grep',
                        '--json=stream',
                    }, -- must have --json=stream
                    grep_open_files = false, -- search in opened files
                    lang = nil, -- string value, specify language for ast-grep `nil` for default 
                }
            }
        })

        pcall(require('telescope').load_extension, 'fzf')
        pcall(require('telescope').load_extension, 'undo')
        pcall(require('telescope').load_extension, 'yank_history')

        local telescope_builtin = require('telescope.builtin')

        vim.keymap.set('n', '<leader>p', telescope_builtin.find_files, {})
        vim.keymap.set('n', '<leader>q', telescope_builtin.buffers, {})
        vim.keymap.set('n', '<leader>g', telescope_builtin.live_grep, {})
        vim.keymap.set('n', '<leader>[', telescope_builtin.treesitter, {})
        vim.keymap.set('n', '<leader>?', telescope_builtin.oldfiles, {})
        vim.keymap.set('n', '<leader>t', telescope_builtin.tags, {})

        vim.keymap.set('n', '<leader>G', telescope.extensions.undo.undo, {})

        vim.keymap.set('n', '<leader>y', telescope.extensions.yank_history.yank_history, {})
    end
}
