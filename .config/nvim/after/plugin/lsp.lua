local lsp = require("lsp-zero")

lsp.ensure_installed({
	'gopls',
})

lsp.preset("recommended")
lsp.setup()
