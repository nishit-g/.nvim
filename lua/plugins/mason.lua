return {
    "williamboman/mason.nvim",
    lazy = false,
    cmd = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUninstall", "MasonUninstallAll", "MasonLog" },
    build = ":MasonUpdate",
    dependencies = {
      {
        "williamboman/mason-lspconfig.nvim",
        lazy = false,
      },
    },
    config = function()
      local status_ok, mason = pcall(require, "mason")
      if not status_ok then
        return
      end

      local status_ok_lsp, mason_lspconfig = pcall(require, "mason-lspconfig")
      if not status_ok_lsp then
        return
      end

      mason.setup{
          ui = {
              icons = {
                  package_installed = "✓",
                  package_pending = "➜",
                  package_uninstalled = "✗"
              }
          }
      }

      mason_lspconfig.setup{}
    end,
}
