if not require("qwox.util").has_plugins("dap") then return end
local dap = require("dap")

vim.keymap.set("n", "<leader>dc", require("dap").continue, { desc = "" })
vim.keymap.set("n", "<leader>dr", require("dap").restart, { desc = "" })
vim.keymap.set("n", "<leader>db", require("dap").toggle_breakpoint, { desc = "" })
vim.keymap.set("n", "<leader>dsover", require("dap").step_over, { desc = "" })
vim.keymap.set("n", "<leader>dsinto", require("dap").step_into, { desc = "" })
vim.keymap.set("n", "<leader>dsout", require("dap").step_out, { desc = "" })
vim.keymap.set("n", "<leader>dq", require("dap").terminate, { desc = "" })
--vim.keymap.set("n", "<leader>dqd", require("dap").disconnect, { desc = "" })

-- dap.adapters.rt_lldb is set in after/plugin/rust.lua : require("rust-tools").setup { ... }
dap.configurations.rust = { -- see https://github.com/leoluz/nvim-dap-go/blob/main/lua/dap-go.lua
    {
        name = "Launch",
        type = "rt_lldb",
        --request = "attach",
        request = "launch",
        --program = "${file}", -- replaced by cargo attribute
        cargo = {
            args = { "build" },
        },
    }
} -- alternative: RustDebuggables


-- rcarriga/nvim-dap-ui
if not require("qwox.util").has_plugins("dapui") then return end

require("dapui").setup {
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
        elements = { {
            id = "scopes",
            size = 0.25
        }, {
            id = "breakpoints",
            size = 0.25
        }, {
            id = "stacks",
            size = 0.25
        }, {
            id = "watches",
            size = 0.25
        } },
        position = "right",
        size = 40
    }, {
        elements = { {
            id = "repl",
            size = 0.5
        }, {
            id = "console",
            size = 0.5
        } },
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

vim.keymap.set("n", "<leader>dt", require("dapui").toggle, { desc = "toggle dap ui" }) -- nil or "sidebar" or "tray"

local dapui = require("dapui")
dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end
