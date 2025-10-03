return {
  settings = {
    basedpyright = {
      disableOrganizeImports = false,
      analysis = {
        autoSearchPaths = true,
        typeCheckingMode = 'basic',
        useLibraryCodeForTypes = true,
        diagnosticSeverityOverrides = {
          reportPrivateImportUsage = false,
        }
      },
    }
  }
}
