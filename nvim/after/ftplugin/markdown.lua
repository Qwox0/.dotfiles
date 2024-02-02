local qwox_util = require("qwox.util")
local buf_path = qwox_util.get_buf_path()

if string.starts_with(buf_path, qwox_util.paths.obsidian) then
    vim.opt_local.conceallevel = 2
end
