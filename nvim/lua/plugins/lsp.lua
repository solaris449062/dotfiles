-- This file installs and configures language-server support.
-- A language server is a separate program that understands one language and
-- sends Neovim information such as diagnostics, definitions, and completions.

return {
  -- nvim-lspconfig supplies server-specific defaults to Neovim's built-in LSP client.
  {
    -- The GitHub repository containing the server configuration files.
    "neovim/nvim-lspconfig",

    -- Load the configurations during startup so Mason-LSPConfig can enable them.
    lazy = false,
  },

  -- Mason is a package manager that installs external developer tools inside Neovim.
  {
    -- The GitHub repository containing Mason.
    "mason-org/mason.nvim",

    -- Update Mason's package registry when the plugin is updated.
    build = ":MasonUpdate",

    -- Use Mason's default settings for now.
    opts = {},
  },

  -- Mason-LSPConfig connects Mason's package names to Neovim's LSP configurations.
  {
    -- The GitHub repository containing the Mason-LSPConfig bridge.
    "mason-org/mason-lspconfig.nvim",

    -- Mason-LSPConfig must load after both Mason and nvim-lspconfig.
    dependencies = {
      "mason-org/mason.nvim",
      "neovim/nvim-lspconfig",
    },

    -- These are the server names used by nvim-lspconfig.
    opts = {
      -- Install these servers automatically through Mason when they are missing.
      -- `gopls` provides Go support.
      -- `jdtls` provides Java support.
      -- `pyright` provides Python type checking and language features.
      ensure_installed = {
        "gopls",
        "jdtls",
        "pyright",
      },

        -- Enable installed servers through vim.lsp.enable().
        -- Java is excluded because lua/plugins/java.lua starts JDTLS with its
        -- Java debugger bundle and project-specific workspace configuration.
        automatic_enable = {
          exclude = {
            "jdtls",
          },
        },
    },

    -- Run this after the plugin and its dependencies have loaded.
    config = function(_, opts)
      -- Show diagnostics as virtual text at the end of the affected line.
      -- Diagnostics are messages such as syntax errors and type errors.
      vim.diagnostic.config({
        virtual_text = true,

        -- Keep diagnostic signs visible in the sign column.
        signs = true,

        -- Underline text associated with a diagnostic.
        underline = true,

        -- Wait until Normal mode before recalculating diagnostics.
        update_in_insert = false,

        -- Sort errors before warnings, hints, and informational messages.
        severity_sort = true,
      })

      -- Ask Mason-LSPConfig to install and automatically enable the servers above.
      -- Neovim 0.11+ uses vim.lsp.enable() internally for this step.
      require("mason-lspconfig").setup(opts)

      -- Define buffer-local keymaps when an LSP client attaches to a buffer.
      -- The keymaps are created only for buffers that actually have LSP support.
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          -- Restrict these mappings to the buffer that received the LSP client.
          local buffer = args.buf

          -- `K` asks the server for documentation for the symbol under the cursor.
          vim.keymap.set("n", "K", vim.lsp.buf.hover, {
            buffer = buffer,
            desc = "LSP hover documentation",
          })

          -- Space followed by `r` then `n` asks the server to rename a symbol.
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, {
            buffer = buffer,
            desc = "LSP rename symbol",
          })

          -- Space followed by `c` then `a` opens available code actions.
          vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {
            buffer = buffer,
            desc = "LSP code action",
          })

          -- `grr` asks the server for references to the symbol under the cursor.
          vim.keymap.set("n", "grr", vim.lsp.buf.references, {
            buffer = buffer,
            desc = "LSP references",
          })
        end,
      })
    end,
  },
}
