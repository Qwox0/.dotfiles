local keys = {
    { "<leader>gg", vim.cmd.Git,                                                desc = "[G]it: open fugitive" },
    { "<leader>gs", function() require("telescope.builtin").git_status() end,   desc = "[G]it: [S]tatus" },
    { "<leader>gb", function() require("telescope.builtin").git_branches() end, desc = "[G]it: [B]ranches" },
    { "<leader>gf", ":Git fetch<CR>",                                           desc = "[G]it: [F]etch" },
    { "<leader>gd", ":Git pull<CR>",                                            desc = "[G]it: Pull [D]own" },
    { "<leader>gu", ":Git push<CR>",                                            desc = "[G]it: Push [U]p" },
    {
        "<leader>gy",
        ":Git fetch<CR>:Git pull<CR>:Git push<CR>",
        desc = "[G]it: s[Y]nc (fetch, pull, push)"
    },

    { "<leader>gaa", ":!git add -A<CR>", desc = "[G]it: [A]dd [A]ll" },

    --nmap("<leader>ga", require("telescope.builtin").git_stash, { desc = "[G]it: [A]dd" })

    -- for fugitive diffsplit:
    { "gh",          ":diffget //2<CR>", desc = "fugitive split: [G]et left" },
    { "gl",          ":diffget //3<CR>", desc = "fugitive split: [G]et right" },
    { "gj",          ":1,$+1diffget //2<CR>", desc = "fugitive split: [G]et left all" },
    { "gk",          ":1,$+1diffget //3<CR>", desc = "fugitive split: [G]et right all" },
}

return { -- Git Ui
    "tpope/vim-fugitive",
    keys = keys,
}
