local qwox_util = require("qwox.util")

---@param cmd string
---@return fun(args: vim.api.keyset.create_user_command.command_args)
local function arg_passthrough(cmd)
    return function(args)
        -- vim.cmd[cmd0] { table.unpack(cmd_args), table.unpack(args.fargs) } -- doesn't work for some reason
        vim.cmd(cmd .. " " .. table.concat(args.fargs), " ")
    end
end


vim.command.set("W", "w", { desc = "Prevent misspelling of :w" })
vim.command.set("Q", "q", { desc = "Prevent misspelling of :q" })
vim.command.set("Wa", "wa", { desc = "Prevent misspelling of :wa" })
vim.command.set("WA", "wa", { desc = "Prevent misspelling of :wa" })
vim.command.set("Wq", "wq", { desc = "Prevent misspelling of :wq" })
vim.command.set("WQ", "wq", { desc = "Prevent misspelling of :wq" })
vim.command.set("Wqa", "wqa", { desc = "Prevent misspelling of :wqa" })
vim.command.set("WQa", "wqa", { desc = "Prevent misspelling of :wqa" })

local function get_selected_text(command_args)
    return require("qwox.util").get_selection_text_of(command_args.line1, 0, command_args.line2, nil)
end

vim.command.set("Wordcount", function(arg)
    local text = get_selected_text(arg)
    print("Wordcount (split by whitespace):", text:wordcount(), " | Wordcount (human words):", text:humanwordcount())
end, { range = true, desc = "Count words (not whitespace) in current line" })
vim.command.set("WordcountNonWhitespace", function(arg)
    print("Wordcount (split by whitespace):", get_selected_text(arg):wordcount())
end, { range = true, desc = "Count words (not whitespace) in current line" })
vim.command.set("WordcountHuman", function(arg)
    print("Wordcount (human words):", get_selected_text(arg):humanwordcount())
end, { range = true, desc = "Count human words in current line" })

vim.command.set("ReverseLine", function()
    qwox_util.set_line(nil, qwox_util.get_line():reverse())
end, { desc = "Count human words in selection" })

vim.command.set("Zen", function() require("qwox.zen").toggle() end, { desc = "Toggle zen mode" })

vim.command.set("SudoWrite", function()
    local path = vim.api.nvim_buf_get_name(0)
    local function handle_event(job_id, data, event)
        if event == "stderr" and string.starts_with(data[1], "[sudo]") then
            local password = vim.fn.inputsecret(data[1])
            vim.fn.chansend(job_id, { password, "" })
        elseif event == "stderr" and data[1] ~= "" then
            vim.notify(data[1])
        elseif event == "stdout" and data[1] == "password_correct" then
            vim.notify("Saving as root user ...")
            local content = vim.api.nvim_buf_get_lines(0, 0, -1, false)
            table.insert(content, "")

            vim.fn.chansend(job_id, content)
            vim.fn.chanclose(job_id, "stdin")
            vim.cmd.edit { path, bang = true }
        end
    end
    vim.fn.jobstart("sudo -S -- bash -c \"echo password_correct; cat > " .. path .. "\"", {
        cwd = vim.fn.getcwd(),
        on_exit = handle_event,
        on_stdout = handle_event,
        on_stderr = handle_event,
    })
end, { desc = "write a file as root" })

vim.command.set("Splitdiff", arg_passthrough("diffsplit"), { nargs = 1, desc = "`:diffsplit` alias" })

vim.command.set("Vdiffsplit", arg_passthrough("vert diffsplit"), { nargs = 1, desc = "`:vert diffsplit` alias" })
vim.command.set("Vsplitdiff", arg_passthrough("vert diffsplit"), { nargs = 1, desc = "`:vert diffsplit` alias" })
