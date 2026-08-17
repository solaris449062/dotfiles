-- This file configures Java language features and Java debugging.
-- JDTLS is the Eclipse Java language server used by Neovim.

return {
  -- nvim-jdtls adds Java-specific LSP commands and DAP integration.
  {
    -- The GitHub mirror of the nvim-jdtls plugin.
    "mfussenegger/nvim-jdtls",

    -- Load this plugin when Neovim opens a Java buffer.
    ft = "java",

    -- nvim-jdtls registers a Java DAP adapter through nvim-dap.
    dependencies = {
      "mfussenegger/nvim-dap",
    },

    -- Start or attach JDTLS whenever a Java buffer triggers this plugin.
    config = function()
      -- Load the Java LSP client and its debugger integration.
      local jdtls = require("jdtls")
      local jdtls_dap = require("jdtls.dap")

      -- Find the nearest Java project root from the current buffer.
      -- A project usually has Git, Maven, or Gradle markers.
      local root_dir = vim.fs.root(0, {
        ".git",
        "mvnw",
        "gradlew",
        "pom.xml",
        "build.gradle",
        "build.gradle.kts",
      })

      -- Do not start a project language server for an unrooted standalone file.
      if not root_dir then
        vim.notify("Java project root not found", vim.log.levels.WARN)
        return
      end

      -- Keep JDTLS indexes in Neovim's state directory, outside the project.
      -- The project name keeps indexes for different projects separate.
      local project_name = vim.fn.fnamemodify(root_dir, ":t")
      local workspace_dir = vim.fn.stdpath("state") .. "/jdtls/" .. project_name

      -- Create the state directory before JDTLS tries to write its indexes.
      vim.fn.mkdir(workspace_dir, "p")

      -- Mason installs the Java debug bundle in this package directory.
      local java_debug_dir = vim.fn.stdpath("data") .. "/mason/packages/java-debug-adapter"

      -- Glob returns every matching debug-bundle JAR as a Lua list.
      local bundles = vim.fn.glob(
        java_debug_dir .. "/extension/server/com.microsoft.java.debug.plugin-*.jar",
        true,
        true
      )

      -- JDTLS loads the Java debugger as an extension bundle at startup.
      local config = {
        -- The `jdtls` executable is installed by Mason and uses SDKMAN's Java.
        cmd = {
          "jdtls",
          "-data",
          workspace_dir,
        },

        -- Restrict this server to the Java project that contains the buffer.
        root_dir = root_dir,

        -- Ask JDTLS to keep Maven and Gradle project metadata synchronized.
        -- This is what lets JDTLS learn that Spring Boot annotations belong to
        -- dependencies declared by the project rather than treating them as
        -- unknown symbols.
        settings = {
          java = {
            configuration = {
              -- Re-import the project automatically after build-file changes.
              updateBuildConfiguration = "automatic",
            },

            -- Download source JARs for dependencies such as spring-context.
            -- Go to definition can then open the actual annotation source.
            maven = {
              downloadSources = true,
            },

            -- Ask the Eclipse importer to download dependency sources too.
            eclipse = {
              downloadSources = true,
            },

            -- Enable source downloads for Gradle imports as well.
            import = {
              gradle = {
                downloadSources = true,
              },
            },

            -- Use decompiled classes as a fallback when no source JAR exists.
            references = {
              includeDecompiledSources = true,
            },
          },
        },

        -- Pass the debugger extension to JDTLS during initialization.
        init_options = {
          bundles = bundles,
        },

        -- Configure Java's DAP adapter after the language server attaches.
        on_attach = function()
          -- Automatically discover Java main classes as DAP configurations.
          jdtls_dap.setup_dap_main_class_configs()

          -- Enable hot code replacement while debugging when supported.
          jdtls.setup_dap({ hotcodereplace = "auto" })
        end,
      }

      -- Start a new JDTLS process or reuse the one already serving this project.
      jdtls.start_or_attach(config)
    end,
  },
}
