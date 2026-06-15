-- =============================================================================
-- init.lua — Modern Neovim config migrated from init.vim
-- Plugin manager: lazy.nvim
-- =============================================================================

vim.g.mapleader = ","
vim.g.maplocalleader = ","

-- OSC52 must be set before opt.clipboard
local ok, osc52 = pcall(require, "vim.ui.clipboard.osc52")
if ok then
  vim.g.clipboard = {
    name = "OSC 52",
    copy = {
      ["+"] = osc52.copy("+"),
      ["*"] = osc52.copy("*"),
    },
    paste = {
      ["+"] = osc52.paste("+"),
      ["*"] = osc52.paste("*"),
    },
  }
end

-- =============================================================================
-- OPTIONS (replaces all your bare `set` commands)
-- =============================================================================
local opt = vim.opt

opt.compatible    = false
opt.mouse         = "a"
opt.background    = "dark"
opt.termguicolors = true
opt.number        = true
opt.relativenumber = true
opt.cursorline    = true
opt.signcolumn    = "yes"
opt.visualbell    = true
opt.showmatch     = true
opt.ignorecase    = true
opt.smartcase     = true
opt.hlsearch      = true
opt.incsearch     = true
opt.gdefault      = true
opt.list          = true
opt.hidden        = true
opt.cmdheight     = 2
opt.updatetime    = 300
opt.encoding      = "utf-8"
opt.fileencoding  = "utf-8"
opt.clipboard     = "unnamedplus"
opt.foldmethod    = "expr"
opt.foldexpr      = "v:lua.vim.treesitter.foldexpr()"
opt.foldlevel     = 99   -- start with all folds open
opt.backspace     = { "indent", "eol", "start" }
opt.tabstop       = 2
opt.softtabstop   = 2
opt.shiftwidth    = 2
opt.expandtab     = true
opt.shortmess:append("c")

-- =============================================================================
-- BOOTSTRAP lazy.nvim
-- =============================================================================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Treesitter must be findable before lazy processes configs
local treesitter_path = vim.fn.stdpath("data") .. "/lazy/nvim-treesitter"
if vim.loop.fs_stat(treesitter_path) then
  vim.opt.rtp:prepend(treesitter_path)
  package.path = treesitter_path .. "/lua/?.lua;" ..
                 treesitter_path .. "/lua/?/init.lua;" ..
                 package.path
end

-- =============================================================================
-- PLUGINS
-- =============================================================================
require("lazy").setup({

  -- ---------------------------------------------------------------------------
  -- COLORSCHEME — nova-vim (your favourite, keeping it)
  -- ---------------------------------------------------------------------------
  {
    "iammerrick/nova-vim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd("colorscheme nova")
    end,
  },

  -- ---------------------------------------------------------------------------
  -- TREESITTER — replaces all the language-specific syntax plugins
  -- (vim-javascript-syntax, yats.vim, typescript-vim, vim-scala highlights, etc.)
  -- ---------------------------------------------------------------------------
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    lazy = false,
    config = function()
      require("nvim-treesitter.config").setup({
        ensure_installed = {
          "lua", "vim", "vimdoc",
          "scala", "rust", "go",
          "javascript", "typescript", "tsx",
          "json", "yaml", "toml",
          "html", "css",
          "graphql",
          "markdown", "markdown_inline",
          "gleam", "ocaml",
        },
        highlight    = { enable = true },
        indent       = { enable = true },
        auto_install = true,
      })
    end,
  },

  -- ---------------------------------------------------------------------------
  -- LSP — replaces coc.nvim entirely
  -- mason.nvim: auto-installs LSP servers
  -- nvim-lspconfig: configures them
  -- ---------------------------------------------------------------------------
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "ts_ls",           -- TypeScript/JavaScript
          "gopls",           -- Go
          "rust_analyzer",   -- Rust (also handled by rustaceanvim)
          "elmls",           -- Elm
          "graphql",         -- GraphQL
          "ocamllsp",        -- OCaml
          -- Note: metals is NOT mason-managed — nvim-metals handles it separately
        },
        automatic_installation = true,
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = { "williamboman/mason-lspconfig.nvim" },
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- Native vim.lsp.config API (nvim 0.11+) — no require('lspconfig') framework,
      -- no deprecation warning. rust_analyzer omitted — rustaceanvim owns it.
      local servers = {
        ts_ls    = {},
        gopls    = {},
        elmls    = {},
        graphql  = {},
        ocamllsp = { settings = { codelens = { enable = true } } },
      }

      for server, config in pairs(servers) do
        config.capabilities = capabilities
        vim.lsp.config(server, config)
        vim.lsp.enable(server)
      end

      -- LSP keymaps
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(ev)
          local opts = { buffer = ev.buf }
          vim.keymap.set("n", "gd",         vim.lsp.buf.definition,     opts)
          vim.keymap.set("n", "gy",         vim.lsp.buf.type_definition, opts)
          vim.keymap.set("n", "gi",         vim.lsp.buf.implementation,  opts)
          vim.keymap.set("n", "gr",         vim.lsp.buf.references,      opts)
          vim.keymap.set("n", "K",          vim.lsp.buf.hover,           opts)
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename,          opts)
          vim.keymap.set("n", "<leader>ac", vim.lsp.buf.code_action,     opts)
          vim.keymap.set("n", "F",          vim.lsp.buf.format,          opts)
          vim.keymap.set("n", "[c",         vim.diagnostic.goto_prev,    opts)
          vim.keymap.set("n", "]c",         vim.diagnostic.goto_next,    opts)
        end,
      })
    end,
  },

  -- ---------------------------------------------------------------------------
  -- SCALA — nvim-metals (never use mason for this, metals manages itself)
  -- ---------------------------------------------------------------------------
  {
    "scalameta/nvim-metals",
    dependencies = { "nvim-lua/plenary.nvim" },
    ft = { "scala", "sbt", "java" },
    config = function()
      local metals = require("metals")
      local metals_config = metals.bare_config()

      metals_config.capabilities = require("cmp_nvim_lsp").default_capabilities()

      metals_config.settings = {
        showImplicitArguments       = true,
        showInferredType            = true,
        showImplicitConversionsAndClasses = true,
        superMethodLensesEnabled    = true,
        enableSemanticHighlighting  = true,
        scalafmtConfigPath          = "",   -- disable metals' own scalafmt
        excludedPackages = {
          "akka.actor.typed.javadsl",
          "com.github.swagger.akka.javadsl",
        },
      }

      -- Metals-specific keymaps (on top of the shared LSP ones)
      metals_config.on_attach = function(_, bufnr)
        local opts = { buffer = bufnr }
        vim.keymap.set("n", "<leader>mc", metals.commands,           opts) -- metals command palette
        vim.keymap.set("n", "<leader>mi", metals.organize_imports,   opts) -- organize imports
        vim.keymap.set("n", "<leader>mh", metals.hover_worksheet,    opts) -- evaluate worksheet expression
        vim.keymap.set("v", "<leader>mr", metals.extract_member,     opts) -- extract to member
      end

      -- nvim-metals manages its own attach — do NOT also add ocamllsp/gopls here
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "scala", "sbt" },
        callback = function()
          metals.initialize_or_attach(metals_config)
        end,
      })

      -- Filetype detection for sbt/ammonite scripts
      vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
        pattern = { "*.sbt", "*.sc" },
        callback = function() vim.bo.filetype = "scala" end,
      })
    end,
  },

  -- ---------------------------------------------------------------------------
  -- RUST — rustaceanvim replaces rust.vim + vim-racer
  -- ---------------------------------------------------------------------------
  {
    "mrcjkb/rustaceanvim",
    version = "^5",
    ft = { "rust" },
    -- No setup() needed — it auto-configures rust-analyzer
  },

  -- ---------------------------------------------------------------------------
  -- GO — keep vim-go for tooling (:GoTest, :GoDebug, etc.)
  -- Treesitter handles highlighting so we disable vim-go's
  -- ---------------------------------------------------------------------------
  {
    "fatih/vim-go",
    ft = "go",
    build = ":GoUpdateBinaries",
    init = function()
      -- Disable vim-go's highlighting (treesitter does it better)
      vim.g.go_highlight_build_constraints = 0
      vim.g.go_highlight_extra_types       = 0
      vim.g.go_highlight_fields            = 0
      vim.g.go_highlight_functions         = 0
      vim.g.go_highlight_methods           = 0
      vim.g.go_highlight_operators         = 0
      vim.g.go_highlight_structs           = 0
      vim.g.go_highlight_types             = 0
      vim.g.go_fmt_command                 = "goimports"
      vim.g.go_auto_type_info              = 1
      vim.g.go_auto_sameids                = 0  -- LSP handles this now
    end,
    config = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "go",
        callback = function()
          local opts = { buffer = true }
          vim.keymap.set("n", "<leader>b", "<Plug>(go-build)",           opts)
          vim.keymap.set("n", "<leader>r", "<Plug>(go-run)",             opts)
          vim.keymap.set("n", "<leader>t", "<Plug>(go-test)",            opts)
          vim.keymap.set("n", "<leader>c", "<Plug>(go-coverage-toggle)", opts)
          vim.keymap.set("n", "<leader>i", "<Plug>(go-info)",            opts)
          vim.bo.expandtab  = false
          vim.bo.tabstop    = 4
          vim.bo.shiftwidth = 4
        end,
      })
    end,
  },

  -- ---------------------------------------------------------------------------
  -- COMPLETION — nvim-cmp replaces coc completion + deoplete + supertab
  -- ---------------------------------------------------------------------------
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp     = require("cmp")
      local luasnip = require("luasnip")

      cmp.setup({
        snippet = {
          expand = function(args) luasnip.lsp_expand(args.body) end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"]      = cmp.mapping.confirm({ select = true }),
          ["<Tab>"]     = cmp.mapping(function(fallback)
            if cmp.visible() then cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then luasnip.expand_or_jump()
            else fallback() end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then luasnip.jump(-1)
            else fallback() end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
        }, {
          { name = "buffer" },
          { name = "path" },
        }),
      })
    end,
  },

  -- ---------------------------------------------------------------------------
  -- FUZZY FINDING — telescope replaces fzf.vim
  -- ---------------------------------------------------------------------------
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    keys = {
      { "<C-p>",      "<cmd>Telescope find_files<cr>",  desc = "Find files" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>",   desc = "Live grep" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>",     desc = "Buffers" },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>",   desc = "Help tags" },
    },
    config = function()
      local telescope = require("telescope")
      telescope.setup({
        defaults = {
          path_display = { "truncate" },
          preview = {
            treesitter = false,  -- telescope's treesitter integration is broken with new API
          },
        },
        pickers = {
          find_files = {
            hidden = true,
            no_ignore = false,
          },
        },
      })
      telescope.load_extension("fzf")
    end,
  },

  -- ---------------------------------------------------------------------------
  -- STATUSLINE — lualine replaces vim-airline
  -- ---------------------------------------------------------------------------
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = {
          theme = "tokyonight",
          globalstatus = true,
        },
        sections = {
          lualine_x = {
            {
              -- Show LSP diagnostics in statusline (replaces airline coc integration)
              function()
                local errors   = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
                local warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
                return string.format("E:%d W:%d", errors, warnings)
              end,
            },
            "encoding", "fileformat", "filetype",
          },
        },
      })
    end,
  },

  -- ---------------------------------------------------------------------------
  -- FORMATTING — conform.nvim replaces vim-autoformat
  -- ---------------------------------------------------------------------------
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          ocaml      = { "ocamlformat" },
          go         = { "goimports" },
          rust       = { "rustfmt" },
          javascript = { "prettier" },
          typescript = { "prettier" },
          json       = { "prettier" },
          lua        = { "stylua" },
        },
        format_on_save = function(bufnr)
          -- Never auto-format Scala — metals rewrites brace→indent syntax
          if vim.bo[bufnr].filetype == "scala" then
            return
          end
          return { timeout_ms = 3000, lsp_fallback = true }
        end,
      })
      vim.keymap.set("n", "<leader>f", function()
        require("conform").format({ async = true, lsp_fallback = true })
      end, { desc = "Format buffer" })
    end,
  },

  -- ---------------------------------------------------------------------------
  -- COMMENTS — Comment.nvim replaces nerdcommenter
  -- ---------------------------------------------------------------------------
  {
    "numToStr/Comment.nvim",
    keys = { "gc", "gb" },  -- lazy-load on first use
    config = function()
      require("Comment").setup()
    end,
  },

  -- ---------------------------------------------------------------------------
  -- AUTOPAIRS — nvim-autopairs replaces delimitMate
  -- ---------------------------------------------------------------------------
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      local autopairs = require("nvim-autopairs")
      autopairs.setup({ check_ts = true })
      -- Integrate with cmp
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
  },

  -- ---------------------------------------------------------------------------
  -- MOTION — flash.nvim replaces vim-easymotion
  -- ---------------------------------------------------------------------------
  {
    "folke/flash.nvim",
    keys = {
      { "s",     mode = { "n", "x", "o" }, function() require("flash").jump() end,   desc = "Flash" },
      { "S",     mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
    },
  },

  -- ---------------------------------------------------------------------------
  -- INDENT GUIDES — indent-blankline replaces indentLine
  -- ---------------------------------------------------------------------------
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("ibl").setup()
    end,
  },

  -- ---------------------------------------------------------------------------
  -- RAINBOW DELIMITERS — replaces rainbow
  -- ---------------------------------------------------------------------------
  {
    "HiPhish/rainbow-delimiters.nvim",
    event = { "BufReadPost", "BufNewFile" },
  },

  -- ---------------------------------------------------------------------------
  -- GIT — gitsigns replaces gitgutter (you had gitgutter keymaps but not the plug)
  -- ---------------------------------------------------------------------------
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("gitsigns").setup({
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns
          local opts = { buffer = bufnr }
          vim.keymap.set("n", "<leader>ga", gs.stage_hunk,   opts)
          vim.keymap.set("n", "<leader>gu", gs.reset_hunk,   opts)
          vim.keymap.set("n", "<leader>gv", gs.preview_hunk, opts)
        end,
      })
    end,
  },

  -- ---------------------------------------------------------------------------
  -- FILE TREE — oil.nvim (edit filesystem like a buffer)
  -- ---------------------------------------------------------------------------
  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    lazy = false,
    config = function()
      require("oil").setup({
        default_file_explorer = true,
        keymaps = {
          ["q"] = "actions.close",
        },
        view_options = {
          show_hidden = true,
          is_always_hidden = function(name)
            return name == ".git"
          end,
        },
        win_options = {
          signcolumn = "yes:2",
        },
      })
      vim.keymap.set("n", "<leader>e", "<cmd>Oil<cr>", { desc = "Open file tree (cwd)" })
      vim.keymap.set("n", "<leader>E", function()
        require("oil").open(vim.fn.expand("%:p:h"))
      end, { desc = "Open file tree (current file dir)" })
    end,
  },


  {
    "vim-test/vim-test",
    keys = {
      { "<leader>tf", "<cmd>TestFile<cr>" },
      { "<leader>ts", "<cmd>TestSuite<cr>" },
      { "<leader>tv", "<cmd>TestVisit<cr>" },
    },
    init = function()
      vim.g["test#strategy"] = "neovim"
    end,
  },

  -- ---------------------------------------------------------------------------
  -- WRITING — vim-pencil (keep as-is)
  -- ---------------------------------------------------------------------------
  { "reedes/vim-pencil", ft = { "markdown", "text", "rst" } },

  -- ---------------------------------------------------------------------------
  -- LANGUAGE EXTRAS (keep, still useful)
  -- ---------------------------------------------------------------------------
  { "mattn/emmet-vim",           ft = { "html", "css", "jsx", "tsx" }, init = function()
      vim.g.user_emmet_leader_key = "<C-Z>"
    end },
  { "ap/vim-css-color",          ft = { "css", "scss", "sass" } },
  { "jparise/vim-graphql",       ft = { "graphql" } },
  { "gleam-lang/gleam.vim",      ft = { "gleam" } },
  { "ElmCast/elm-vim",           ft = { "elm" } },
  { "maxmellon/vim-jsx-pretty",  ft = { "jsx", "tsx" } },

  -- ---------------------------------------------------------------------------
  -- REMOVED (no replacements needed):
  --   syntastic      → LSP diagnostics
  --   ALE            → LSP diagnostics + conform.nvim
  --   coc.nvim       → nvim-lspconfig + nvim-cmp
  --   deoplete       → nvim-cmp
  --   supertab       → nvim-cmp Tab mapping
  --   vim-racer      → rustaceanvim
  --   vim-autoformat → conform.nvim
  --   vim-airline    → lualine
  --   indentLine     → indent-blankline
  --   vim-easymotion → flash.nvim
  --   nerdcommenter  → Comment.nvim
  --   delimitMate    → nvim-autopairs
  --   rainbow        → rainbow-delimiters.nvim
  --   fzf.vim        → telescope
  -- ---------------------------------------------------------------------------

}, {
  -- lazy.nvim options
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip", "matchit", "matchparen",
        "netrwPlugin", "tarPlugin", "tohtml",
        "tutor", "zipPlugin",
      },
    },
  },
})

-- =============================================================================
-- KEYMAPS (non-plugin)
-- =============================================================================

-- Window navigation (replaces your nnoremap <leader>h/j/k/l)
vim.keymap.set("n", "<leader>h", "<C-w>h")
vim.keymap.set("n", "<leader>j", "<C-w>j")
vim.keymap.set("n", "<leader>k", "<C-w>k")
vim.keymap.set("n", "<leader>l", "<C-w>l")

-- Terminal window navigation
vim.keymap.set("t", "<leader>h", "<C-\\><C-n><C-w>h")
vim.keymap.set("t", "<leader>j", "<C-\\><C-n><C-w>j")
vim.keymap.set("t", "<leader>k", "<C-\\><C-n><C-w>k")
vim.keymap.set("t", "<leader>l", "<C-\\><C-n><C-w>l")

-- Quick save / escape
vim.keymap.set("n", "<leader>w", "<cmd>w<cr>")
vim.keymap.set("i", "<leader>q", "<Esc>")

-- Buffer delete (gb was :bd — keep it, but note Comment.nvim uses gb for block comments)
-- Reassign bd to <leader>bd to avoid conflict
vim.keymap.set("n", "<leader>bd", "<cmd>bd<cr>")

-- =============================================================================
-- FILETYPE OVERRIDES
-- =============================================================================
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = { "*.go" },
  callback = function()
    vim.bo.expandtab  = false
    vim.bo.tabstop    = 4
    vim.bo.shiftwidth = 4
  end,
})

-- =============================================================================
-- FILETYPE / SYNTAX
-- =============================================================================
vim.cmd("filetype indent on")
vim.cmd("filetype plugin on")
vim.cmd("syntax on")
