-- these are all utilities plugins that are basically one liners and require almost no configuration
return {
  'tpope/vim-fugitive',
  'tpope/vim-surround',
  'tpope/vim-sleuth',

  'tridactyl/vim-tridactyl',

  'preservim/nerdcommenter',

  {
    "LintaoAmons/scratch.nvim",
    event = "VeryLazy",
    config = function ()
      vim.keymap.set("n", "<leader><tab>", "<cmd>Scratch<cr>")
    end
  }, -- scratch

  {
    "gbprod/yanky.nvim",
    opts = {},
    config = function ()
      pcall(require('telescope').load_extension, 'yank_history')
    end
  }, -- yanky

  {
    "shortcuts/no-neck-pain.nvim",
    version = '*',
    config = function ()
      require("no-neck-pain").setup({
        width = 210
      })


      vim.keymap.set("n", "<leader>n", "<cmd>NoNeckPain<cr>")
    end
  }, -- no neck pain

  {
    "tpope/vim-rhubarb",
    version = '*',
  }, -- rhubarb (for git browse)
}
