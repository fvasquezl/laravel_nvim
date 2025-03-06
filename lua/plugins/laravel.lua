return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      { "williamboman/mason.nvim" },
      { "williamboman/mason-lspconfig.nvim" },
      { "phpactor/phpactor", build = "composer install --no-dev -o" },
    },
    config = function()
      local lspconfig = require("lspconfig")
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = { "intelephense", "tailwindcss", "emmet_ls" },
      })

      lspconfig.intelephense.setup({
        settings = {
          intelephense = {
            stubs = {
              "bcmath",
              "bz2",
              "Core",
              "curl",
              "date",
              "dom",
              "fileinfo",
              "filter",
              "hash",
              "json",
              "libxml",
              "mbstring",
              "openssl",
              "pcre",
              "PDO",
              "pdo_mysql",
              "Phar",
              "readline",
              "Reflection",
              "session",
              "SimpleXML",
              "sodium",
              "SPL",
              "standard",
              "tokenizer",
              "xml",
              "xmlwriter",
              "yaml",
              "zip",
              "zlib",
              "Laravel_12",
            },
            environment = {
              phpVersion = "8.4",
            },
            files = {
              maxSize = 10000000, -- Soporte para archivos más grandes
              associations = { "*.php", "*.blade.php" }, -- Incluir Blade y PHP
            },
            completion = {
              fullyQualifyGlobalConstantsAndFunctions = true, -- Autocompletar namespaces completos
              triggerParameterHints = true, -- Mostrar sugerencias de parámetros
            },
            diagnostics = {
              enable = true, -- Diagnósticos activos
            },
            indexing = {
              exclude = { "**/vendor/**" }, -- Ignorar `vendor/`
            },
          },
        },
      })

      lspconfig.emmet_ls.setup({
        filetypes = { "html", "css", "blade" }, -- Soporte para Blade
      })
    end,
  },
  {
    "tpope/vim-fugitive", -- Soporte para GitHub
  },
  {
    "nvim-telescope/telescope.nvim", -- Navegación
    dependencies = {
      { "nvim-lua/plenary.nvim" },
    },
    config = function()
      require("telescope").setup({
        defaults = {
          mappings = {
            i = {
              ["<C-g>"] = function()
                require("telescope.builtin").git_files()
              end,
            },
          },
        },
      })
    end,
  },
  {
    "L3MON4D3/LuaSnip", -- Snippets
  },
  {
    "hrsh7th/nvim-cmp", -- Autocompletado
    dependencies = {
      { "hrsh7th/cmp-nvim-lsp" },
      { "hrsh7th/cmp-buffer" },
      { "saadparwaiz1/cmp_luasnip" },
    },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
        }),
        mapping = {
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
        },
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "php", "html", "css", "javascript", "bash", "lua" },
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        autotag = { enable = true }, -- Cierra automáticamente las etiquetas HTML
      })

      -- Asignar archivos Blade a HTML
      vim.filetype.add({
        extension = {
          blade = "html",
        },
      })
    end,
  },
  {
    "jwalton512/vim-blade",
  },
  {
    "akinsho/toggleterm.nvim",
    config = function()
      require("toggleterm").setup({
        open_mapping = [[<C-\>]],
        direction = "horizontal",
        size = 20,
        auto_close = false, -- Desactivamos auto_close para un mejor control manual
      })

      -- Mapeo para cerrar el terminal con <leader>q
      vim.api.nvim_set_keymap(
        "n",
        "<leader>q",
        "<cmd>lua require('toggleterm').toggle_all()<CR>",
        { noremap = true, silent = true }
      )
    end,
  },

  --  composer global require friendsofphp/php-cs-fixer
  --  npm install -g blade-formatter
  --  npm install -g prettier
  {
    "stevearc/conform.nvim",
    opts = {
      format_on_save = {
        timeout_ms = 3000,
        lsp_fallback = true,
      },
      formatters_by_ft = {
        php = { "php-cs-fixer" }, -- Formatea archivos PHP (controladores, modelos, etc.)
        blade = { "blade-formatter" }, -- Formatea vistas Blade
        html = { "prettier" }, -- Opcional: para archivos HTML
        css = { "prettier" }, -- Opcional: para CSS (incluye Tailwind)
        javascript = { "prettier" }, -- Opcional: para JS
      },
    },
  },
}
