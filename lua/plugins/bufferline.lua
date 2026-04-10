return {
    'akinsho/bufferline.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function ()
        local bufferline = require('bufferline')
        bufferline.setup {
            options = {
                numbers = 'ordinal',
                offsets = {
                    {
                        filetype = 'NvimTree',
                        text = function()
                            return vim.fn.getcwd()
                        end,
                        highlight = 'Directory',
                        text_align = 'left'
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

        vim.keymap.set('n', '<leader>x', ':bd<cr>', {})
    end
}
