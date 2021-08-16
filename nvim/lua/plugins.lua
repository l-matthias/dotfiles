local execute = vim.api.nvim_command
local fn = vim.fn

-- Autoinstall packer if not installed
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
	execute("!git clone https://github.com/wbthomason/packer.nvim " .. install_path)
	execute("packadd packer.nvim")
end

vim.cmd("autocmd BufWritePost plugins.lua PackerCompile") -- Auto compile when there are changes in plugins.lua

return require("packer").startup(function(use)
	use("wbthomason/packer.nvim")

	----------------------------------------------------------------------
	-- editing
	use({
		"folke/which-key.nvim",
		config = function()
			require("whichkey")
		end,
		opt = true,
		keys = "<space>",
	})

	use({
		"ahmedkhalf/project.nvim",
		config = function()
			require("project_nvim").setup()
		end,
	})

	use({
		"terrortylor/nvim-comment",
		event = "BufReadPre",
		config = function()
			require("nvim_comment").setup()
		end,
	})

	use({
		"phaazon/hop.nvim",
		config = function()
			require("hop").setup()
		end,
		cmd = { "HopChar2", "HopChar1" },
	})

	use({ "windwp/nvim-autopairs", opt = true, after = "nvim-compe" })

	----------------------------------------------------------------------
	-- LSP
	use({
		"jose-elias-alvarez/null-ls.nvim",
		event = "BufReadPre",
		config = function()
			require("lsp.null-lsp")
		end,
		requires = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
	})

	use({ "kabouzeid/nvim-lspinstall", cmd = { "LspInstall", "LspUninstall" } })

	use({
		"neovim/nvim-lspconfig",
		event = "BufReadPre",
		config = function()
			require("lsp")
		end,
	})

	use({
		"hrsh7th/nvim-compe",
		event = "InsertEnter",
		config = function()
			require("completion")
		end,
	})

	use({ "kosayoda/nvim-lightbulb", event = "BufReadPre" })

	use({ "hrsh7th/vim-vsnip", event = "InsertEnter" })

	use({
		"lewis6991/gitsigns.nvim",
		event = "BufReadPre",
		config = function()
			require("git")
		end,
	})

	use({
		"simrat39/rust-tools.nvim",
		config = function()
			require("rust-tools").setup({ server = { on_attach = require("lsp.utils").on_attach } })
		end,
		ft = "rust",
		requires = { "neovim/nvim-lspconfig" },
	})

	----------------------------------------------------------------------
	-- TREESITTER
	use({
		"nvim-treesitter/nvim-treesitter",
		event = "BufRead",
		branch = "0.5-compat",
		run = ":TSUpdate",
		config = function()
			require("treesitter")
		end,
	})

	use({
		"lukas-reineke/indent-blankline.nvim",
		event = "BufReadPre",
		config = function()
			require("indentline")
		end,
	})

	----------------------------------------------------------------------
	-- EDITOR
	use({
		"glepnir/galaxyline.nvim",
		branch = "main",
		event = "BufReadPre",
		config = function()
			require("gline")
		end,
		requires = { "kyazdani42/nvim-web-devicons" },
	})

	use({
		"jose-elias-alvarez/buftabline.nvim",
		config = function()
			require("buftabline").setup({
				tab_format = " #{n}:#{b}#{f} ",
				go_to_maps = false,
			})
			require("buftabline.utils").map({ prefix = "<leader>b", cmd = "buffer" })
		end,
		event = "BufReadPre",
		requires = { "kyazdani42/nvim-web-devicons" },
	})

	use({
		"norcalli/nvim-colorizer.lua",
		event = "BufReadPre",
		config = function()
			require("colorizer").setup()
		end,
	})

	use({
		"TimUntersberger/neogit",
		config = function()
			require("neogit").setup({ integrations = { diffview = true } })
		end,
		cmd = "Neogit",
		requires = { "nvim-lua/plenary.nvim", { "sindrets/diffview.nvim", after = "neogit" } },
	})

	----------------------------------------------------------------------
	-- TELESCOPE
	use({
		"nvim-telescope/telescope.nvim",
		requires = {
			{ "nvim-lua/popup.nvim" },
			{ "nvim-lua/plenary.nvim" },
			{ "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
		},
		config = function()
			require("telescope-config")
		end,
		cmd = "Telescope",
	})
end)
