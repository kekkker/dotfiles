require('vgit').setup({
  keymaps = {
    ['n <leader>gk'] = function() require('vgit').hunk_up() end,
    ['n <leaders>gj'] = function() require('vgit').hunk_down() end,
    ['n <leader>gb'] = function() require('vgit').buffer_blame_preview() end,
  }
})
