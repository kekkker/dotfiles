require("kek.remap")
require("kek.set")
require("kek.packer")
vim.cmd("hi! link NormalFloat Normal")

-- Set the colors for vim-signify
vim.api.nvim_command('highlight SignifySignAdd guifg=#ffffff')
vim.api.nvim_command('highlight SignifySignChange guifg=#ffffff')
vim.api.nvim_command('highlight SignifySignDelete guifg=#ffffff')
