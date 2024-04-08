local keys = {
    { "<leader>df", function() require("dapui").float_element() end,   desc = "[D]ap [F]loat UI" },
    { "<leader>de", function() require("dapui").eval() end,            desc = "[D]ap [F]loat UI" },
    { "<leader>dt", function() require("dapui").toggle() end,          desc = "[D]ap toggle [U]I" }, -- nil or "sidebar" or "tray"
}

local function config()
    local dap = require("dap")
    local dapui = require("dapui")
    dapui.setup {
        controls = {
            element = "repl",
            enabled = true,
            icons = {
                disconnect = "",
                pause = "",
                play = "",
                run_last = "",
                step_back = "",
                step_into = "",
                step_out = "",
                step_over = "",
                terminate = ""
            }
        },
        element_mappings = {},
        expand_lines = true,
        floating = {
            border = "single",
            mappings = {
                close = { "q", "<Esc>" }
            }
        },
        force_buffers = true,
        icons = {
            collapsed = "",
            current_frame = "",
            expanded = ""
        },
        layouts = { {
            elements = {
                { id = "scopes",  size = 0.70 },
                -- { id = "breakpoints", size = 0.25 },
                -- { id = "stacks",  size = 0.20 },
                { id = "watches", size = 0.30 }
            },
            position = "right",
            size = 60
        }, {
            elements = {
                { id = "repl",    size = 0.7 },
                { id = "console", size = 0.3 }
            },
            position = "bottom",
            size = 10
        } },
        mappings = {
            edit = "e",
            expand = { "<CR>", "<2-LeftMouse>" },
            open = "o",
            remove = "d",
            repl = "r",
            toggle = "t"
        },
        render = {
            indent = 1,
            max_value_lines = 100
        }
    }

    dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
    dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
    dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end
end

return {
    "rcarriga/nvim-dap-ui",
    dependencies = {
        "mfussenegger/nvim-dap",
        "nvim-neotest/nvim-nio",
    },
    keys = keys,
    config = config,
}
