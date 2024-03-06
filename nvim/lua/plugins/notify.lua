local function config()
    require("notify").setup {
        background_colour = "#000000"
    }

    -- see <https://github.com/rcarriga/nvim-notify/wiki/Usage-Recipes>
    vim.notify = require("notify")
    vim.lsp.handlers["$/progress"] = require("qwox.notify").lsp_status_update
    vim.lsp.handlers["window/showMessage"] = require("qwox.notify").lsp_messages
end

return {
    "rcarriga/nvim-notify",
    lazy = false,
    priority = 9999,
    config = config,
}
