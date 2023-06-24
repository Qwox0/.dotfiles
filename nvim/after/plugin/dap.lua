local qwox_util = require("qwox.util")
if not qwox_util.has_plugins("dap") then return end

local dap = require("dap")

local function is_active()
    return dap.session() ~= nil
end

local function continue()
    if is_active() or not qwox_util.is_filetype("rust") then return dap.continue() end
    vim.api.nvim_command("RustDebuggables")
end

vim.keymap.set("n", "<leader>dc", continue, { desc = "[D]ap [C]ontinue" })
vim.keymap.set("n", "<leader>dr", dap.restart, { desc = "[D]ap [R]estart" })
vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "[D]ap [B]reakpoint" })
vim.keymap.set("n", "<leader>dj", dap.step_over, { desc = "[D]ap step over" })
vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "[D]ap step [I]nto" })
vim.keymap.set("n", "<leader>do", dap.step_out, { desc = "[D]ap step [O]ut" })
vim.keymap.set("n", "<leader>dq", dap.terminate, { desc = "[D]ap [Q]uit" })
--vim.keymap.set("n", "<leader>dqd", dap.disconnect, { desc = "" })

-- dap.adapters.rt_lldb is set in after/plugin/rust.lua : require("rust-tools").setup { ... }
-- see https://github.com/leoluz/nvim-dap-go/blob/main/lua/dap-go.lua
--[[
dap.configurations.rust = { {
    name = "Launch",
    type = "rt_lldb",
    request = "launch",
    program = function()
        vim.api.nvim_command("RustDebuggables")
    end,
    cargo = {
        args = { "build" },
    },
} }
]] -- replaced with: `:RustDebuggables`


--[[
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
        elements = {
            { id = "scopes",  size = 0.40 },
            -- { id = "breakpoints", size = 0.25 },
            { id = "stacks",  size = 0.20 },
            { id = "watches", size = 0.40 }
        },
        position = "right",
        size = 60
    }, {
        elements = {
            { id = "repl",    size = 0.9 },
            { id = "console", size = 0.1 }
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

vim.keymap.set("n", "<leader>dt", require("dapui").toggle, { desc = "toggle dap ui" }) -- nil or "sidebar" or "tray"

local dapui = require("dapui")
dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end
]]
require("nvim-dap-virtual-text").setup {
    --virt_text_pos = vim.fn.has 'nvim-0.10' == 1 and 'inline' or 'eol',
    virt_text_pos = 'eol',
}
