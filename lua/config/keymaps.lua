local opts = { noremap = true, silent = true }

-- useless mappings
vim.keymap.set('n', 'K', '<nop>', opts)
vim.keymap.set('n', 'J', '<nop>', opts)

vim.keymap.set('n', '<Up>', '<nop>', opts)
vim.keymap.set('n', '<Down>', '<nop>', opts)

-- command line mode
vim.keymap.set('n', 'q:', '<nop>', opts)

-- indent/de-indent using keys on normal/visual mode
vim.keymap.set('n', '<Left>', '<<', opts)
vim.keymap.set('v', '<Left>', '<gv', opts)
vim.keymap.set('n', '<Right>', '>>', opts)
vim.keymap.set('v', '<Right>', '>gv', opts)

-- split current file
vim.keymap.set('n', '<leader>bv', ':botright vsplit<cr>', opts)
vim.keymap.set('n', '<leader>bs', ':botright split<cr>', opts)

-- open split
vim.keymap.set('n', '<space>', 'za', opts)
