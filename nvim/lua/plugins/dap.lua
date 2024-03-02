local qwox_util = require("qwox.util")

local debug_prompt = {
    ---@type table<string, fun():nil>
    _items = {
        ["List Breakpoints"] = function()
            require("telescope").extensions.dap.list_breakpoints()
        end,
        --["List Variables"] = require("telescope").extensions.dap.variables,
        ["Stack/Frames"] = function() require("telescope").extensions.dap.frames() end,
        ["RustDebuggables"] = function() require("rust-tools").debuggables.debuggables() end,
    },
    opts = {
        prompt = "Debugger",
        kind = "qwox/debug-prompt",
    },
    items = function(self) return vim.tbl_keys(self._items) end,
    select = function(self, choice) self._items[choice]() end,
    open = function(self)
        vim.ui.select(self:items(), self.opts, function(choice) self:select(choice) end)
    end
}

local keys = {
    { "<leader>dd", function() debug_prompt:open() end,                desc = "Open [D]ebug Menu" },
    {
        "<leader>dc",
        function()
            local dap = require("dap")
            local function is_active() return dap.session() ~= nil end
            if is_active() or not qwox_util.is_filetype("rust") then
                dap.continue()
            else
                vim.api.nvim_command("RustDebuggables")
            end
        end,
        desc = "[D]ap [C]ontinue"
    },
    { "<leader>dr", function() require("dap").restart() end,           desc = "[D]ap [R]estart" },
    { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "[D]ap [B]reakpoint" },
    { "<leader>dj", function() require("dap").step_over() end,         desc = "[D]ap step over" },
    { "<leader>di", function() require("dap").step_into() end,         desc = "[D]ap step [I]nto" },
    { "<leader>do", function() require("dap").step_out() end,          desc = "[D]ap step [O]ut" },
    { "<leader>dq", function() require("dap").terminate() end,         desc = "[D]ap [Q]uit" },
    --nmap("<leader>dqd", dap.disconnect, { desc = "" })

    { "<leader>df", function() require("dapui").float_element() end,   desc = "[D]ap [F]loat UI" },
    { "<leader>de", function() require("dapui").eval() end,            desc = "[D]ap [F]loat UI" },
    { "<leader>dt", function() require("dapui").toggle() end,          desc = "[D]ap toggle [U]I" }, -- nil or "sidebar" or "tray"
}

local function config()
    local dap = require("dap")

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
]]
    -- replaced with: `:RustDebuggables`

    require("qwox.telescope").load_extension("dap")

    -- rcarriga/nvim-dap-ui
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

    --[[
    require("nvim-dap-virtual-text").setup {
        --virt_text_pos = vim.fn.has "nvim-0.10" == 1 and "inline" or "eol",
        virt_text_pos = "eol",
    }
    ]]

    require("nvim-dap-virtual-text").setup {
        enabled = true,
        enabled_commands = false, -- create commands DapVirtualTextEnable, DapVirtualTextDisable, DapVirtualTextToggle, (DapVirtualTextForceRefresh for refreshing when debug adapter did not notify its termination)
        highlight_changed_variables = true,
        highlight_new_as_changed = false,
        show_stop_reason = true,
        commented = false,             -- prefix virtual text with comment string
        only_first_definition = false, -- only show virtual text at first definition (if there are multiple)
        all_references = true,
        clear_on_continue = false,     -- clear virtual text on "continue" (might cause flickering when stepping)
        ---A callback that determines how a variable is displayed or whether it should be omitted
        ---@return string|nil A text how the virtual text should be displayed or nil, if this variable shouldn't be displayed
        display_callback = function(variable, buf, stackframe, node, options)
            if options.virt_text_pos == 'inline' then
                return ' = ' .. variable.value
            else
                return variable.name .. ' = ' .. variable.value
            end
        end,
        --virt_text_pos = vim.fn.has 'nvim-0.10' == 1 and 'inline' or 'eol', -- see `:h nvim_buf_set_extmark()`
        virt_text_pos = "eol",

        -- experimental features:
        all_frames = false,     -- show virtual text for all stack frames not only current. Only works for debugpy on my machine.
        virt_lines = false,     -- show virtual lines instead of virtual text (will flicker!)
        virt_text_win_col = nil -- position the virtual text at a fixed window column (starting from the first text column) ,
        -- e.g. 80 to position at column 80, see `:h nvim_buf_set_extmark()`
    }
end

return {
    "mfussenegger/nvim-dap",
    dependencies = {
        "rcarriga/nvim-dap-ui",            -- configuaration for nvim-dap
        "theHamsta/nvim-dap-virtual-text", -- show debugger state as virtual text

        "nvim-telescope/telescope.nvim",
        "nvim-telescope/telescope-dap.nvim",
        "rcarriga/cmp-dap",
    },
    keys = keys,
    config = config,
}
