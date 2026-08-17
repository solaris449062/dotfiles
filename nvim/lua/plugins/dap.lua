-- This file installs and configures the Debug Adapter Protocol client.
-- DAP is the protocol Neovim uses to communicate with language debuggers.

return {
  -- nvim-dap is Neovim's client for Debug Adapter Protocol servers.
  {
    -- The GitHub repository containing the DAP client.
    "mfussenegger/nvim-dap",

    -- These plugins add a visual debugger interface and Go-specific behavior.
    dependencies = {
      -- Show scopes, stacks, breakpoints, and the debugger console in panels.
      {
        "rcarriga/nvim-dap-ui",

        -- nvim-dap-ui uses nvim-nio for asynchronous Neovim work.
        dependencies = {
          "nvim-neotest/nvim-nio",
        },
      },

      -- Add Delve launch and Go test configurations to nvim-dap.
      "leoluz/nvim-dap-go",
    },

    -- These mappings load nvim-dap when the first debugger action is used.
    keys = {
      -- Space followed by `d` then `c` continues or starts a debug session.
      {
        "<leader>dc",
        function()
          require("dap").continue()
        end,
        desc = "Debug continue",
      },

      -- Space followed by `d` then `b` adds or removes a breakpoint.
      {
        "<leader>db",
        function()
          require("dap").toggle_breakpoint()
        end,
        desc = "Debug toggle breakpoint",
      },

      -- Space followed by `d` then `n` steps over the current source line.
      {
        "<leader>dn",
        function()
          require("dap").step_over()
        end,
        desc = "Debug step over",
      },

      -- Space followed by `d` then `i` enters the function at the current line.
      {
        "<leader>di",
        function()
          require("dap").step_into()
        end,
        desc = "Debug step into",
      },

      -- Space followed by `d` then `o` exits the current function.
      {
        "<leader>do",
        function()
          require("dap").step_out()
        end,
        desc = "Debug step out",
      },

      -- Space followed by `d` then `u` shows or hides the debugger panels.
      {
        "<leader>du",
        function()
          require("dapui").toggle()
        end,
        desc = "Debug toggle UI",
      },

      -- In a Go test, Space followed by `d` then `t` debugs the nearest test.
      {
        "<leader>dt",
        function()
          require("dap-go").debug_test()
        end,
        desc = "Debug nearest Go test",
      },
    },

    -- Configure the DAP client after lazy.nvim has loaded its dependencies.
    config = function()
      -- Load the DAP client and its panel UI.
      local dap = require("dap")
      local dapui = require("dapui")

      -- Use nvim-dap-ui's documented default layout.
      dapui.setup()

      -- Open the debugger panels whenever a session starts.
      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end

      -- Close the panels after a debug session ends.
      dap.listeners.before.event_terminated.dapui_config = function()
        dapui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        dapui.close()
      end

      -- Register Delve-backed configurations for Go programs and tests.
      require("dap-go").setup()
    end,
  },

  -- Mason installs external debugger programs and makes them available to Neovim.
  {
    -- The GitHub repository connecting Mason to nvim-dap.
    "jay-babu/mason-nvim-dap.nvim",

    -- Mason and nvim-dap must be loaded before this bridge is configured.
    dependencies = {
      "mason-org/mason.nvim",
      "mfussenegger/nvim-dap",
    },

    opts = {
      -- `delve` is the Go debugger that implements the DAP server.
      ensure_installed = {
        "delve",

        -- `javadbg` is Mason-Nvim-DAP's name for the Java debug bundle.
        -- Java will use this bundle through JDTLS rather than as a standalone
        -- executable adapter.
        "javadbg",
      },
    },
  },
}
