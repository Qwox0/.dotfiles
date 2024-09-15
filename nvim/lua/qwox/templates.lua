local f = io.popen("find " .. require("qwox.util").paths.nvim_config .. "/templates -mindepth 1")
if f == nil then return end

---@param path string
for path in f:lines() do
    ---@type string
    local ext = path:sub0((path:rfind0("%.") or -1) + 1)
    vim.autocmd.set("BufNewFile", { pattern = "*." .. ext, command = ":0r " .. path })
end
