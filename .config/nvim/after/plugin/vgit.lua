require('vgit').setup({
  keymaps = {
    ['n <leader>gb'] = function() require('vgit').buffer_blame_preview() end,
  }
})
