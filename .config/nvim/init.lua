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
	use({ "hrsh7th/nvim-cmp" })
	use({ "hrsh7th/cmp-nvim-lsp" })
	use({ "hrsh7th/cmp-buffer" })
	use({ "hrsh7th/cmp-path" })
	use({ "hrsh7th/cmp-cmdline" })
	use({ "tanvirtin/vgit.nvim", requires = { "nvim-lua/plenary.nvim" } })
	use({ "m4xshen/autoclose.nvim" })
	use({ "nvim-lualine/lualine.nvim", requires = { "nvim-tree/nvim-web-devicons", opt = true } })
	use({ "mbbill/undotree" })
	use({
		"VonHeikemen/lsp-zero.nvim",
		branch = "v2.x",
		requires = {
			-- LSP Support
			{ "neovim/nvim-lspconfig" }, -- Required
			{ -- Optional
				"williamboman/mason.nvim",
				run = function()
					pcall(vim.cmd, "MasonUpdate")
				end,
			},
			{ "williamboman/mason-lspconfig.nvim" }, -- Optional

			-- Autocompletion
			{ "hrsh7th/nvim-cmp" }, -- Required
			{ "hrsh7th/cmp-nvim-lsp" }, -- Required
			{ "L3MON4D3/LuaSnip" }, -- Required
		},
	})
	use({ "stevearc/conform.nvim" })
    use({"justinmk/vim-dirvish"})
    use({"tamago324/lir.nvim"})
end)
require("autoclose").setup()

-- PACKER --

-- nvim-cmp --
local cmp = require("cmp")
cmp.setup({
	mapping = cmp.mapping.preset.insert({
		["<C-b>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-e>"] = cmp.mapping.abort(),
		["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
	}),
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
	}, {
		{ name = "buffer" },
	}),
})
-- nvim-cmp --

-- LSP ZERO --
lsp = require("lsp-zero")

lsp.ensure_installed({
	"clangd",
})

lsp.preset("recommended")
lsp.on_attach(function(client, bufnr)
	local opts = { buffer = buffnr, remap = false }
	vim.keymap.set("n", "gd", function()
		vim.lsp.buf.definition()
	end, opts)
	vim.keymap.set("n", "K", function()
		vim.lsp.buf.hover()
	end, opts)
	vim.keymap.set("n", "<leader>vws", function()
		vim.lsp.buf.workspace_symbol()
	end, opts)
	vim.keymap.set("n", "<leader>vd", function()
		vim.diagnostic.open_float()
	end, opts)
	vim.keymap.set("n", "<leader>vd", function()
		vim.diagnostic.goto_next()
	end, opts)
	vim.keymap.set("n", "[d", function()
		vim.diagnostic.goto_next()
	end, opts)
	vim.keymap.set("n", "]d", function()
		vim.diagnostic.goto_prev()
	end, opts)
	vim.keymap.set("n", "<leader>la", function()
		vim.lsp.buf.code_action()
	end, opts)
end)
lsp.setup()
-- LSP ZERO --

-- LUA LINE --
require("lualine").setup({
	options = {
		icons_enabled = true,
		theme = "onedark",
		component_separators = "|",
		section_separators = "",
	},
	sections = {
		lualine_a = {
			{
				"buffers",
			},
		},
		lualine_c = {
			{
				"diagnostics",
			},
		},
	},
})
-- LUA LINE --

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
		yamlfmt = {
			command = "/home/kek/.bin/yamlfmt",
			args = { "-formatter", "indentless_arrays=false,retain_line_breaks=true,include_document_start=true", "-" },
		},
        black = {
            command = "/home/kek/py-user/bin/black",
            args = {    "--stdin-filename",    "$FILENAME",    "--quiet",    "-",}
      }
	},
	formatters_by_ft = {
		sh = { "shfmt" },
		bash = { "shfmt" },
		terraform = { "terraform_fmt" },
		yaml = { "yamlfmt" },
		yml = { "yamlfmt" },
		python = { "black" },
	},
})

vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	callback = function(args)
		require("conform").format({ bufnr = args.buf })
	end,
})
-- CONFORM --

-- REMAPS
vim.keymap.set("n", "<leader>w", ":w<CR>")
vim.keymap.set("n", "<leader>q", ":q!<CR>")
vim.keymap.set("n", "<C-Tab>", ":asdasd")

function _lazygit_toggle()
	local Terminal = require("toggleterm.terminal").Terminal
	local lazygit = Terminal:new({ cmd = "lazygit", hidden = true, direction = "float" })
	lazygit:toggle()
end

vim.api.nvim_set_keymap("n", "<leader>gg", "<cmd>lua _lazygit_toggle()<CR>", { noremap = true, silent = true })

vim.api.nvim_create_autocmd("BufWritePre", {
	buffer = buffer,
	callback = function()
		vim.lsp.buf.format({ async = false })
	end,
})
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("x", "<leader>p", '"_dP')
vim.keymap.set("n", "L", vim.cmd.bnext)
vim.keymap.set("n", "H", vim.cmd.bprevious)

vim.keymap.set("n", "<C-t>", function()
	ui.nav_file(1)
end)
vim.keymap.set("n", "<C-h>", function()
	ui.nav_file(2)
end)
vim.keymap.set("n", "<C-n>", function()
	ui.nav_file(3)
end)

vim.keymap.set("n", "<leader>fw", builtin.live_grep, {})
vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
vim.keymap.set("n", "<leader>gs", builtin.git_status, {})
vim.keymap.set("n", "<leader>b", builtin.buffers, {})
vim.keymap.set("n", "<leader>ps", function()
	builtin.grep_string({ search = vim.fn.input("Grep > ") })
end)

vim.keymap.set("n", "<leader>x", vim.cmd.bd)
-- REMAPS

-- SETS --
vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 2
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

vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25
vim.g.netrw_altv = 1
vim.g.netrw_winsize = 25
vim.g.netrw_liststyle = 3

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

vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25
vim.g.netrw_altv = 1
vim.g.netrw_winsize = 25
vim.g.netrw_liststyle = 3

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true
-- SETS --
--
--
local actions = require'lir.actions'
local mark_actions = require 'lir.mark.actions'
local clipboard_actions = require'lir.clipboard.actions'

require'lir'.setup {
  show_hidden_files = true,
  ignore = {}, -- { ".DS_Store", "node_modules" } etc.
  devicons = {
    enable = false,
    highlight_dirname = false
  },
  mappings = {
    ['l']     = actions.edit,
    ['<C-s>'] = actions.split,
    ['<C-v>'] = actions.vsplit,
    ['<C-t>'] = actions.tabedit,

    ['h']     = actions.up,
    ['q']     = actions.quit,

    ['D']     = actions.mkdir,
    ['F']     = actions.newfile,
    ['R']     = actions.rename,
    ['@']     = actions.cd,
    ['Y']     = actions.yank_path,
    ['.']     = actions.toggle_show_hidden,
    ['d']     = actions.delete,

    ['J'] = function()
      mark_actions.toggle_mark()
      vim.cmd('normal! j')
    end,
    ['C'] = clipboard_actions.copy,
    ['X'] = clipboard_actions.cut,
    ['P'] = clipboard_actions.paste,
  },
  float = {
    winblend = 1,
    curdir_window = {
      enable = true,
      highlight_dirname = true
    },
    win_opts = function()
      local width = math.floor(vim.o.columns)
      local height = math.floor(vim.o.lines)
      return {
        border = {
          "+", "─", "+", "│", "+", "─", "+", "│",
        },
        width = width,
        height = height,
        row = 1,
        col = math.floor((vim.o.columns - width) / 2),
      }
    end,


  },
  hide_cursor = true
}

vim.api.nvim_create_autocmd({'FileType'}, {
  pattern = {"lir"},
  callback = function()
    -- use visual mode
    vim.api.nvim_buf_set_keymap(
      0,
      "x",
      "J",
      ':<C-u>lua require"lir.mark.actions".toggle_mark("v")<CR>',
      { noremap = true, silent = true }
    )
  
    -- echo cwd
    vim.api.nvim_echo({ { vim.fn.expand("%:p"), "Normal" } }, false, {})
  end
})
vim.keymap.set("n", "<leader>e", ":lua require'lir.float'.toggle()<CR>")
