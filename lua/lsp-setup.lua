-- [[ Configure LSP ]]
-- Border for hovers
vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = "single" })

-- Border for diagnostics
vim.diagnostic.config{ severity_sort = true, float = { border = 'rounded' } }

-- mason-lspconfig requires that these setup functions are called in this order
-- before setting up the servers.
require('mason').setup()

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
--
--  If you want to override the default filetypes that your language server will attach to you can
--  define the property 'filetypes' to the map in question.
local servers = {
  -- clangd = {},
  -- gopls = {},
  pyright = {},
  -- rust_analyzer = {},
  -- tsserver = {},
  html = { filetypes = { 'html', 'twig', 'hbs', 'jinja2s'} },

  ltex = {
    filetypes = {
      'markdown',
      'latex',
    },
    ltex = {
      language = "auto",
      diagnosticSeverity = "information",
      sentenceCacheSize = 2000,
      additionalRules = {
        enablePickyRules = true,
        motherTongue = "fr",
      },
      enabledRules = {
        en = { "EN_CONSISTENT_APOS" },
      },
      disabledRules = {
        fr = { "APOS_TYP", "FRENCH_WHITESPACE", "CHANGE", "ISSUE" },
        en = { "DASH_RULE", "TWO_HYPHENS", "CHANGE", "ISSUE" },
      },
    }
  },

  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
      -- NOTE: toggle below to ignore Lua_LS's noisy `missing-fields` warnings
      -- diagnostics = { disable = { 'missing-fields' } },
    },
  },
}

-- Setup neovim lua configuration
require('neodev').setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

for name, opts in pairs(servers) do
  vim.lsp.config(name, opts)
end

-- Ensure the servers above are installed
require('mason-lspconfig').setup {
  ensure_installed = vim.tbl_keys(servers),
}

-- vim: ts=2 sts=2 sw=2 et
