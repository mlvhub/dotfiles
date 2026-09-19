-- =============================================================================
-- init.lua — pruned, phone-first Neovim config
-- Languages: OCaml, Scala, TypeScript/JS, HTML, CSS, Lua, Markdown
-- Requires Neovim >= 0.11 (native vim.lsp.config / vim.lsp.enable)
-- =============================================================================

vim.g.mapleader = ","
vim.g.maplocalleader = ","

vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0

-- -----------------------------------------------------------------------------
-- CLIPBOARD — OSC 52 for COPY only. Paste is served from Neovim's own register
-- so it never waits on a terminal response (fixes the "Waiting for OSC 52" hang
-- in Termux / Zellij). Phone → Neovim paste: use terminal paste in insert mode.
-- -----------------------------------------------------------------------------
do
	local ok, osc52 = pcall(require, "vim.ui.clipboard.osc52")
	if ok then
		local function paste_reg()
			return { vim.fn.split(vim.fn.getreg('"'), "\n"), vim.fn.getregtype('"') }
		end
		vim.g.clipboard = {
			name = "OSC 52 (copy only)",
			copy = { ["+"] = osc52.copy("+"), ["*"] = osc52.copy("*") },
			paste = { ["+"] = paste_reg, ["*"] = paste_reg },
		}
	end
end

-- =============================================================================
-- OPTIONS
-- =============================================================================
local opt = vim.opt

opt.mouse = "a"
opt.termguicolors = true
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.signcolumn = "yes"
opt.showmatch = true
opt.ignorecase = true
opt.smartcase = true
opt.list = true
opt.cmdheight = 0
opt.updatetime = 300
opt.clipboard = "unnamedplus"
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opt.foldlevel = 99
opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.undofile = true
opt.splitright = true
opt.splitbelow = true
opt.scrolloff = 4

-- =============================================================================
-- BOOTSTRAP lazy.nvim
-- =============================================================================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- =============================================================================
-- PLUGINS
-- =============================================================================
require("lazy").setup({

	-- COLORSCHEME ---------------------------------------------------------------
	{
		"iammerrick/nova-vim",
		lazy = false,
		priority = 1000,
		config = function()
			vim.cmd("colorscheme nova")
			local hl = vim.api.nvim_set_hl
			-- subtle heading bars, nova palette
			hl(0, "RenderMarkdownH1Bg", { bg = "#4A5A64", bold = true })
			hl(0, "RenderMarkdownH2Bg", { bg = "#44525B", bold = true })
			hl(0, "RenderMarkdownH3Bg", { bg = "#3F4C55", bold = true })
			hl(0, "RenderMarkdownH4Bg", { bg = "#3F4C55" })
			hl(0, "RenderMarkdownH5Bg", { bg = "#3F4C55" })
			hl(0, "RenderMarkdownH6Bg", { bg = "#3F4C55" })
			-- inline code: readable yellow on a slightly darker block
			hl(0, "RenderMarkdownCodeInline", { fg = "#DADA93", bg = "#2F3C44" })
			hl(0, "RenderMarkdownCode", { bg = "#33404A" }) -- fenced blocks
		end,
	},

	-- TREESITTER ----------------------------------------------------------------
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		lazy = false,
		config = function()
			require("nvim-treesitter.config").setup({
				ensure_installed = {
					"lua",
					"vim",
					"vimdoc",
					"ocaml",
					"ocaml_interface",
					"scala",
					"javascript",
					"typescript",
					"tsx",
					"html",
					"css",
					"json",
					"yaml",
					"toml",
					"markdown",
					"markdown_inline",
					"git_config",
					"gitcommit",
					"diff",
					"kdl",
				},
				highlight = { enable = true },
				indent = { enable = true },
				auto_install = true,
			})
		end,
	},

	-- LSP -----------------------------------------------------------------------
	-- mason manages ts_ls / html / cssls.
	-- ocamllsp is NOT mason-managed: it must come from the project's opam switch
	-- (opam install ocaml-lsp-server ocamlformat) so it matches the compiler.
	-- metals is NOT mason-managed: nvim-metals handles it.
	{
		"williamboman/mason.nvim",
		build = ":MasonUpdate",
		opts = {},
	},
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
		opts = {
			ensure_installed = { "ts_ls", "html", "cssls" },
			automatic_enable = false, -- we call vim.lsp.enable ourselves below
		},
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = { "saghen/blink.cmp" },
		config = function()
			local capabilities = require("blink.cmp").get_lsp_capabilities()

			local servers = {
				ts_ls = {},
				html = {},
				cssls = {},
				ocamllsp = { settings = { codelens = { enable = true } } },
				marksman = {},
			}

			for name, cfg in pairs(servers) do
				cfg.capabilities = capabilities
				vim.lsp.config(name, cfg)
				vim.lsp.enable(name)
			end

			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(ev)
					local map = function(lhs, rhs, desc)
						vim.keymap.set("n", lhs, rhs, { buffer = ev.buf, desc = desc })
					end
					map("gd", vim.lsp.buf.definition, "Go to definition")
					map("gy", vim.lsp.buf.type_definition, "Go to type definition")
					map("gi", vim.lsp.buf.implementation, "Go to implementation")
					map("gr", vim.lsp.buf.references, "References")
					map("K", vim.lsp.buf.hover, "Hover")
					map("<leader>rn", vim.lsp.buf.rename, "Rename symbol")
					map("<leader>ac", vim.lsp.buf.code_action, "Code action")
					map("[d", function()
						vim.diagnostic.jump({ count = -1, float = true })
					end, "Prev diagnostic")
					map("]d", function()
						vim.diagnostic.jump({ count = 1, float = true })
					end, "Next diagnostic")
					map("<leader>ld", vim.diagnostic.open_float, "Line diagnostics")
				end,
			})

			vim.diagnostic.config({
				virtual_text = { spacing = 2, prefix = "●" },
				severity_sort = true,
			})
		end,
	},

	-- SCALA — nvim-metals -------------------------------------------------------
	{
		"scalameta/nvim-metals",
		dependencies = { "nvim-lua/plenary.nvim", "saghen/blink.cmp" },
		ft = { "scala", "sbt", "java" },
		config = function()
			local metals = require("metals")
			local cfg = metals.bare_config()
			cfg.capabilities = require("blink.cmp").get_lsp_capabilities()
			cfg.settings = {
				showImplicitArguments = true,
				showInferredType = true,
				showImplicitConversionsAndClasses = true,
				superMethodLensesEnabled = true,
				enableSemanticHighlighting = true,
				scalafmtConfigPath = "",
				excludedPackages = {
					"akka.actor.typed.javadsl",
					"com.github.swagger.akka.javadsl",
				},
			}
			cfg.on_attach = function(_, bufnr)
				local map = function(mode, lhs, rhs, desc)
					vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
				end
				map("n", "<leader>mc", metals.commands, "Metals commands")
				map("n", "<leader>mi", metals.organize_imports, "Organize imports")
				map("n", "<leader>mh", metals.hover_worksheet, "Hover worksheet")
				map("v", "<leader>mr", metals.extract_member, "Extract member")
			end

			vim.api.nvim_create_autocmd("FileType", {
				pattern = { "scala", "sbt" },
				callback = function()
					metals.initialize_or_attach(cfg)
				end,
			})
			vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
				pattern = { "*.sbt", "*.sc" },
				callback = function()
					vim.bo.filetype = "scala"
				end,
			})
		end,
	},

	-- COMPLETION — blink.cmp ----------------------------------------------------
	{
		"saghen/blink.cmp",
		version = "1.*", -- pulls prebuilt fuzzy binary, no Rust toolchain needed
		event = "InsertEnter",
		opts = {
			keymap = {
				preset = "enter", -- <CR> accepts
				["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
				["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
				["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
			},
			completion = {
				list = { selection = { preselect = true, auto_insert = false } },
				documentation = { auto_show = true, auto_show_delay_ms = 200 },
			},
			signature = { enabled = true },
			sources = { default = { "lsp", "path", "snippets", "buffer" } },
		},
	},

	-- PICKER — fzf-lua (fastest option; ideal over SSH from the phone) ----------
	{
		"ibhagwan/fzf-lua",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		cmd = "FzfLua",
		keys = {
			{ "<C-p>", "<cmd>FzfLua files<cr>", desc = "Find files" },
			{ "<leader>fg", "<cmd>FzfLua live_grep<cr>", desc = "Live grep" },
			{ "<leader>fw", "<cmd>FzfLua grep_cword<cr>", desc = "Grep word under cursor" },
			{ "<leader>fb", "<cmd>FzfLua buffers<cr>", desc = "Buffers" },
			{ "<leader>fh", "<cmd>FzfLua helptags<cr>", desc = "Help tags" },
			{ "<leader>fr", "<cmd>FzfLua resume<cr>", desc = "Resume last picker" },
			{ "<leader>fs", "<cmd>FzfLua lsp_document_symbols<cr>", desc = "Document symbols" },
			{ "<leader>fd", "<cmd>FzfLua diagnostics_document<cr>", desc = "Diagnostics" },
			{ "<leader>gs", "<cmd>FzfLua git_status<cr>", desc = "Git status" },
		},
		opts = {
			"default-title",
			files = {
				fd_opts = "--color=never --type f --hidden --follow --no-ignore "
					.. "--exclude .git --exclude node_modules --exclude _build --exclude _opam "
					.. "--exclude target --exclude .metals --exclude .bloop --exclude .bsp "
					.. "--exclude dist --exclude build --exclude .cache --exclude .venv",
			},
			winopts = { preview = { layout = "vertical", vertical = "down:45%" } }, -- narrow screens
		},
	},

	-- STATUSLINE ----------------------------------------------------------------
	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
			options = { theme = "auto", globalstatus = true },
			sections = {
				lualine_x = { "diagnostics", "encoding", "filetype" },
			},
		},
	},

	-- FORMATTING — conform.nvim -------------------------------------------------
	{
		"stevearc/conform.nvim",
		event = "BufWritePre",
		keys = {
			{
				"<leader>F",
				function()
					require("conform").format({ async = true, lsp_fallback = true })
				end,
				desc = "Format buffer",
			},
		},
		opts = {
			formatters_by_ft = {
				ocaml = { "ocamlformat" },
				javascript = { "prettier" },
				typescript = { "prettier" },
				typescriptreact = { "prettier" },
				html = { "prettier" },
				css = { "prettier" },
				json = { "prettier" },
				lua = { "stylua" },
			},
			format_on_save = function(bufnr)
				if vim.bo[bufnr].filetype == "scala" then
					return
				end -- metals rewrites syntax
				return { timeout_ms = 3000, lsp_fallback = true }
			end,
		},
	},

	-- AUTOPAIRS -----------------------------------------------------------------
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		opts = { check_ts = true },
	},

	-- MOTION — flash.nvim (easymotion successor: `s` + 2 chars + label) --------
	{
		"folke/flash.nvim",
		event = "VeryLazy",
		opts = {},
		keys = {
			{
				"s",
				mode = { "n", "x", "o" },
				function()
					require("flash").jump()
				end,
				desc = "Flash jump",
			},
			{
				"S",
				mode = { "n", "x", "o" },
				function()
					require("flash").treesitter()
				end,
				desc = "Flash treesitter",
			},
		},
	},

	-- GIT — signs + hunks -------------------------------------------------------
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPost", "BufNewFile" },
		opts = {
			on_attach = function(bufnr)
				local gs = require("gitsigns")
				local map = function(lhs, rhs, desc)
					vim.keymap.set("n", lhs, rhs, { buffer = bufnr, desc = desc })
				end
				map("<leader>ga", gs.stage_hunk, "Stage hunk")
				map("<leader>gu", gs.reset_hunk, "Reset hunk")
				map("<leader>gv", gs.preview_hunk, "Preview hunk")
				map("<leader>gb", gs.blame_line, "Blame line")
				map("]h", function()
					gs.nav_hunk("next")
				end, "Next hunk")
				map("[h", function()
					gs.nav_hunk("prev")
				end, "Prev hunk")
			end,
		},
	},

	-- GIT — diffview (PR-style review of local changes) -------------------------
	{
		"sindrets/diffview.nvim",
		cmd = { "DiffviewOpen", "DiffviewFileHistory", "DiffviewClose" },
		keys = {
			{ "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Diff: working tree" },
			{
				"<leader>gD",
				"<cmd>DiffviewOpen origin/main...HEAD<cr>",
				desc = "Diff: branch vs origin/main (PR view)",
			},
			{ "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "File history" },
			{ "<leader>gq", "<cmd>DiffviewClose<cr>", desc = "Close diffview" },
		},
		opts = {},
	},

	-- GIT — lazygit in a float --------------------------------------------------
	{
		"kdheepak/lazygit.nvim",
		cmd = "LazyGit",
		dependencies = { "nvim-lua/plenary.nvim" },
		keys = {
			{ "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
		},
		init = function()
			vim.g.lazygit_floating_window_scaling_factor = 1.0 -- full screen
			vim.g.lazygit_floating_window_use_plenary = 0
			vim.g.lazygit_floating_window_border_chars = { "", "", "", "", "", "", "", "" } -- no border
		end,
	},

	-- FILE TREE — oil.nvim ------------------------------------------------------
	{
		"stevearc/oil.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		lazy = false,
		keys = {
			{ "<leader>e", "<cmd>Oil<cr>", desc = "Oil (cwd)" },
			{
				"<leader>E",
				function()
					require("oil").open(vim.fn.expand("%:p:h"))
				end,
				desc = "Oil (file dir)",
			},
		},
		opts = {
			default_file_explorer = true,
			keymaps = { ["q"] = "actions.close" },
			view_options = {
				show_hidden = true,
				is_always_hidden = function(name)
					return name == ".git"
				end,
			},
			win_options = { signcolumn = "yes:2" },
		},
	},

	-- MARKDOWN — in-buffer rendering (works over SSH, no browser) ---------------
	{
		"MeanderingProgrammer/render-markdown.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
		ft = { "markdown" },
		keys = {
			{ "<leader>tm", "<cmd>RenderMarkdown toggle<cr>", ft = "markdown", desc = "Toggle markdown render" },
		},
		opts = {},
	},

	-- DISCOVERABILITY — which-key -----------------------------------------------
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {
			preset = "helix", -- compact layout, good on narrow screens
			spec = {
				{ "<leader>f", group = "find" },
				{ "<leader>g", group = "git" },
				{ "<leader>m", group = "metals" },
				{ "<leader>b", group = "buffer" },
				{ "<leader>t", group = "toggle" },
			},
		},
		keys = {
			{
				"<leader>?",
				function()
					require("which-key").show({ global = false })
				end,
				desc = "Buffer keymaps",
			},
		},
	},
}, {
	performance = {
		rtp = {
			disabled_plugins = {
				"gzip",
				"tarPlugin",
				"tohtml",
				"tutor",
				"zipPlugin",
				"netrwPlugin",
			},
		},
	},
})

-- =============================================================================
-- KEYMAPS (non-plugin)
-- Commenting: Neovim's built-in `gc` / `gcc` (no plugin needed).
-- =============================================================================
local map = vim.keymap.set

-- Window navigation
map("n", "<leader>h", "<C-w>h", { desc = "Window left" })
map("n", "<leader>j", "<C-w>j", { desc = "Window down" })
map("n", "<leader>k", "<C-w>k", { desc = "Window up" })
map("n", "<leader>l", "<C-w>l", { desc = "Window right" })
map("t", "<leader>h", "<C-\\><C-n><C-w>h")
map("t", "<leader>j", "<C-\\><C-n><C-w>j")
map("t", "<leader>k", "<C-\\><C-n><C-w>k")
map("t", "<leader>l", "<C-\\><C-n><C-w>l")

-- Quick save / escape / buffers
map("n", "<leader>w", "<cmd>w<cr>", { desc = "Save" })
map("i", "<leader>q", "<Esc>", { desc = "Escape" })
map("n", "<leader>bd", "<cmd>bd<cr>", { desc = "Delete buffer" })
map("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight" })

-- Keep cursor centered on jumps (helps on a short screen)
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")
