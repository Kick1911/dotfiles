local pyright_opts = {
  single_file_support = true,
  settings = {
    pyright = {
      disableLanguageServices = false,
      disableOrganizeImports = false
    },
    python = {
      pythonPath = "~/.pyenv/versions/webapp/bin/python",
      analysis = {
        autoImportCompletions = true,
        autoSearchPaths = true,
        diagnosticMode = "workspace", -- openFilesOnly, workspace
        typeCheckingMode = "off", -- off, basic, strict
        useLibraryCodeForTypes = true
      }
    }
  },
}


require('lspconfig').pyright.setup(pyright_opts)
