vim.g.mapleader = " "
vim.cmd([[colorscheme vim]])

-- PACKER --
vim.cmd([[packadd packer.nvim]])

require("packer").startup(function(use)
        use("wbthomason/packer.nvim")

        use({
                "nvim-telescope/telescope.nvim",
                requires = { { "nvim-lua/plenary.nvim" } },
        })

        use("nvim-treesitter/nvim-treesitter", {})

        use({
                "akinsho/toggleterm.nvim",
                tag = "*",
                config = function()
                        require("toggleterm").setup()
                end,
        })
        use({ "tanvirtin/vgit.nvim", requires = { "nvim-lua/plenary.nvim" } })
        -- use({ "m4xshen/autoclose.nvim" })
        use({ "nvim-lualine/lualine.nvim", requires = { "nvim-tree/nvim-web-devicons", opt = true } })
        use({ "mbbill/undotree" })
	use({ "hrsh7th/cmp-nvim-lsp" })
	use({ "hrsh7th/cmp-buffer" })
	use({ "hrsh7th/cmp-path" })
	use({ "hrsh7th/cmp-cmdline" })
	use({ "hrsh7th/nvim-cmp" })
	use({ "L3MON4D3/LuaSnip" })
	use({ "saadparwaiz1/cmp_luasnip" })
	use({ "tamago324/lir.nvim" })
        use({ "stevearc/conform.nvim" })
        use({ "justinmk/vim-dirvish" })
        use({ "ThePrimeagen/harpoon" })
        use({ "tpope/vim-fugitive" })
end)
--require("autoclose").setup()
-- PACKER --
-- LSP
vim.lsp.enable('clangd')
vim.keymap.set('n', 'gd', '<c-]>')
vim.keymap.set('n', '<c-a>', '<c-x>')
vim.diagnostic.config({
    -- virtual_lines = true,
    virtual_text = true,

})
vim.keymap.set("n", "<leader>la", function()
		vim.lsp.buf.code_action()
end, opts)
-- LSP

-- cmp --
local cmp = require("cmp")
local luasnip = require("luasnip")
require("luasnip.loaders.from_vscode").lazy_load()

cmp.setup({
	snippet = {
		-- REQUIRED - you must specify a snippet engine
		expand = function(args)
			require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
		end,
	},
	window = {
		-- completion = cmp.config.window.bordered(),
		-- documentation = cmp.config.window.bordered(),
	},
	mapping = cmp.mapping.preset.insert({
		["<CR>"] = cmp.mapping.confirm({ select = true }),
		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			-- this will auto complete if our cursor in next to a word and we press tab
			-- elseif has_words_before() then
			--     cmp.complete()
			else
				fallback()
			end
		end, { "i", "s" }),

		["<S-Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { "i", "s" }),

		["<C-Tab>"] = cmp.mapping(function(fallback)
			if luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			-- this will auto complete if our cursor in next to a word and we press tab
			-- elseif has_words_before() then
			--     cmp.complete()
			else
				fallback()
			end
		end, { "i", "s" }),
	}),
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		{ name = "luasnip" }, -- For luasnip users.
	}, {
		{ name = "buffer" },
	}),
})

cmp.setup.cmdline({ "/", "?" }, {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = "buffer" },
	},
})

cmp.setup.cmdline(":", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = "path" },
	}, {
		{ name = "cmdline" },
	}),
	matching = { disallow_symbol_nonprefix_matching = false },
})

-- cmp --


-- TELESCOPE --
builtin = require("telescope.builtin")
require("telescope").setup({
	defaults = {
		layout_strategy = "horizontal",
		layout_config = {
			horizontal = {
				prompt_position = "top",
				width = { padding = 0 },
				height = { padding = 0 },
				preview_width = 0.5,
			},
		},
		sorting_strategy = "ascending",
	},
})

-- TREESITTER --
require("nvim-treesitter.configs").setup({
	-- A list of parser names, or "all" (the five listed parsers should always be installed)
	ensure_installed = { "c", "lua", "go", "rust", "yaml", "python" },

	-- Install parsers synchronously (only applied to `ensure_installed`)
	sync_install = false,

	-- Automatically install missing parsers when entering buffer
	-- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
	auto_install = true,

	highlight = {
		enable = true,
	},
})
-- TREESITTER --

-- UNDOTREE --
vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
-- UNDOTREE --

-- VGIT --
require("vgit").setup({
	keymaps = {
		["n <leader>gk"] = function()
			require("vgit").hunk_up()
		end,
		["n <leaders>gj"] = function()
			require("vgit").hunk_down()
		end,
		["n <leader>gb"] = function()
			require("vgit").buffer_blame_preview()
		end,
	},
})
-- VGIT --

-- CONFORM --
require("conform").setup({
	formatters = {
		--yamlfmt = {
		--command = "/home/kek/.bin/yamlfmt",
		--args = { "-formatter", "indentless_arrays=false,retain_line_breaks=true,include_document_start=true", "-" },
		--},
		black = {
			command = "/home/kek/py-user/bin/black",
			args = { "--stdin-filename", "$FILENAME", "--quiet", "-" },
		},
		astyle = {
			command = "astyle",
			args = { "--style=kr", "--indent=spaces=4" },
		},
	},
	formatters_by_ft = {
		sh = { "shfmt" },
		bash = { "shfmt" },
		terraform = { "terraform_fmt" },
		--yaml = { "yamlfmt" },
		--yml = { "yamlfmt" },
		python = { "black" },
		c = { "astyle" },
		cpp = { "astyle" },
		rust = { "rustfmt" },
	},
})

vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	callback = function(args)
		require("conform").format({ bufnr = args.buf })
	end,
})
-- CONFORM --

-- HARPOON --
local mark = require("harpoon.mark")
local ui = require("harpoon.ui")
require("harpoon").setup({
	global_settings = {
		-- sets the marks upon calling `toggle` on the ui, instead of require `:w`.
		save_on_toggle = false,

		-- saves the harpoon file upon every change. disabling is unrecommended.
		save_on_change = true,

		-- sets harpoon to run the command immediately as it's passed to the terminal when calling `sendCommand`.
		enter_on_sendcmd = false,

		-- closes any tmux windows harpoon that harpoon creates when you close Neovim.
		tmux_autoclose_windows = false,

		-- filetypes that you want to prevent from adding to the harpoon list menu.
		excluded_filetypes = { "harpoon" },

		-- set marks specific to each git branch inside git repository
		mark_branch = false,

		-- enable tabline with harpoon marks
		tabline = true,
		tabline_prefix = "   ",
		tabline_suffix = "   ",
	},
})

vim.keymap.set("n", "<leader>a", mark.add_file)
vim.keymap.set("n", "<leader>h", ui.toggle_quick_menu)

vim.keymap.set("n", "<leader>r", function()
	ui.nav_file(1)
end)
vim.keymap.set("n", "<leader>t", function()
	ui.nav_file(2)
end)
vim.keymap.set("n", "<leader>y", function()
	ui.nav_file(3)
end)
vim.keymap.set("n", "<leader>i", function()
	ui.nav_file(4)
end)
-- HARPOON --

-- FUGITIVE --
vim.keymap.set("n", "<leader>gs", vim.cmd.Git)
-- FUGITIVE --

-- REMAPS
vim.keymap.set("n", "<leader>w", ":w<CR>")
vim.keymap.set("n", "<leader>q", ":q!<CR>")

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("x", "<leader>p", '"_dP')

vim.keymap.set("n", "<leader>fw", builtin.live_grep, {})
vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
vim.keymap.set('n', '<leader>fr', function()
  local dir = vim.fn.expand('%:p:h')
  builtin.find_files({cwd = dir})
end, { desc = "Reletive find ripgrep." })

vim.keymap.set("n", "<leader>gs", builtin.git_status, {})
vim.keymap.set("n", "<leader>pp", builtin.git_files, {})
vim.keymap.set("n", "<leader>b", builtin.buffers, {})
vim.keymap.set("n", "<leader>ps", function()
	builtin.grep_string({ search = vim.fn.input("Grep > ") })
end)
vim.keymap.set("n", "<leader>e", ":Ex<CR>")

vim.keymap.set("n", "<Tab>", "<C-o>", { noremap = true, silent = true })
vim.keymap.set("n", "<S-Tab>", "<C-i>", { noremap = true, silent = true })
-- REMAPS

-- SETS --
vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.wrap = false

vim.opt.hlsearch = true
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.updatetime = 50
vim.opt.clipboard = "unnamedplus"

vim.opt.signcolumn = "yes"
vim.wo.signcolumn = "yes"
vim.cmd("highlight SignColumn guibg=black")
vim.cmd("hi! link NormalFloat Normal")

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

-- SETS --
vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.wrap = false

vim.opt.hlsearch = true
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.updatetime = 50
vim.opt.clipboard = "unnamedplus"

vim.opt.signcolumn = "yes"
vim.wo.signcolumn = "yes"
vim.cmd("highlight SignColumn guibg=black")
vim.cmd("hi! link NormalFloat Normal")

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true
-- SETS --
--
--
vim.keymap.set("n", "<leader>x", ":bd<CR>")

-- Horizontal split (silent)
vim.keymap.set('n', '<leader>th', function()
  local dir = vim.fn.expand('%:p:h')
  vim.cmd('silent !tmux split-window -h -c ' .. vim.fn.shellescape(dir) .. ' >/dev/null 2>&1')
end, { desc = "Tmux horizontal split (silent)" })

-- Vertical split (silent)
vim.keymap.set('n', '<leader>tv', function()
  local dir = vim.fn.expand('%:p:h')
  vim.cmd('silent !tmux split-window -v -c ' .. vim.fn.shellescape(dir) .. ' >/dev/null 2>&1')
end, { desc = "Tmux vertical split (silent)" })

-- Netrw
vim.g.netrw_banner = 0 -- Hide the Netrw banner on top
vim.g.netrw_altv = 1 -- Create the split of the Netrw window to the left
vim.g.netrw_browse_split = 0
vim.g.netrw_liststyle = 4 -- Set the styling of the file list to be one column with files inside
vim.g.netrw_winsize = 14 -- Set the width of the "drawer"
