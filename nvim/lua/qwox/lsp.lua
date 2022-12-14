local nnoremap = require("qwox.keymap").nnoremap
local inoremap = require("qwox.keymap").inoremap
local telescope = require("telescope.builtin")

local custom_attach = function(client, bufnr)
    --nnoremap("gd", function() vim.lsp.buf.definition() end,             "goto definition")
    nnoremap("gd", function() telescope.lsp_definitions() end,             "goto definition")
    nnoremap("gi", function() vim.lsp.buf.implementation() end, "goto implementation")
    nnoremap("<leader>ji", function () telescope.lsp_implementations() end,     "show implementations")
    --nnoremap("<leader>jr", function() vim.lsp.buf.references() end,     "show references")
    nnoremap("<leader>jr", function () telescope.lsp_references() end,     "show references")
    nnoremap("<leader>jh", function() vim.lsp.buf.hover() end,          "show hint hover")
    nnoremap("<leader>jn", function() vim.lsp.buf.rename() end,         "rename")
    nnoremap("<leader>jf", function() vim.lsp.buf.format() end,         "format buffer")
    nnoremap("<leader>jd", function() vim.diagnostic.open_float() end,  "show diagnostics")
    --nnoremap("<leader>jd", function() telescope.diagnostics() end,  "show diagnostics")
    nnoremap("<leader>ja", function() vim.lsp.buf.code_action() end,    "show code actions")
    --[[
    nnoremap("<leader>ja", function() vim.lsp.buf.code_action() end,    "show code actions")
    nnoremap("<leader>jco", function() vim.lsp.buf.code_action({
            filter = function(code_action)
                if not code_action or not code_action.data then
                    return false
                end

                local data = code_action.data.id
                return string.sub(data, #data - 1, #data) == ":0"
            end,
            apply = true
        })
    end, "do first code action")

    ]]
    --nnoremap("<leader>vws", function() vim.lsp.buf.workspace_symbol() end)
    --nnoremap("[d", function() vim.diagnostic.goto_next() end)
    --nnoremap("]d", function() vim.diagnostic.goto_prev() end)

    -- Ctrl+H = show variable description
    nnoremap("<C-h>", function() vim.lsp.buf.signature_help() end)
    inoremap("<C-h>", function() vim.lsp.buf.signature_help() end)
end

--local custom_capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())
local custom_capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

local get_config = function(config)
    if type(config) ~= "table" then config = {} end
    return vim.tbl_deep_extend("force", {
        capabilities = custom_capabilities,
        on_attach = custom_attach,
    }, config or {})

end

-- server: string (e.g. "rust_analyzer")
-- config: table
local setup_server = function(server, config)
    require("lspconfig")[server].setup(get_config(config))
end

return {
    setup_server = setup_server,
    get_config = get_config,
}
