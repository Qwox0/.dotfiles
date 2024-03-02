local function config()
    vim.notify = require("notify")
    require("notify").setup {
        background_colour = "#000000"
    }
end

return {
    "rcarriga/nvim-notify",
    lazy = false,
    priority = 9999,
    config = config,
}
