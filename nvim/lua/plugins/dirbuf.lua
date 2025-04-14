local function sort_directories_first(left, right)
    if left.ftype ~= right.ftype then
        if left.ftype == "directory" then
            return true
        elseif right.ftype == "directory" then
            return false
        end
    end
    return left.fname:lower() < right.fname:lower()
end

return {
    "elihunter173/dirbuf.nvim",
    lazy = false,
    keys = {
        { "<leader>e", vim.cmd.Dirbuf, desc = "explore with vim file manager" },
    },
    opts = {
        show_hidden = true,
        sort_order = sort_directories_first,
        -- write_cmd = "DirbufSync -confirm",
        write_cmd = "DirbufSync",
    },
    -- also see <../../after/syntax/dirbuf.lua>
}
