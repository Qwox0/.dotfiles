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

    { "<leader>gh",  ":diffget //2<CR>", desc = "diffsplit [G]et left ([H])" },
    { "<leader>gl",  ":diffget //3<CR>", desc = "diffsplit [G]et right ([L])" },

    { "<leader>gaa", ":!git add -A<CR>", desc = "[G]it: [A]dd [A]ll" },

    --nmap("<leader>ga", require("telescope.builtin").git_stash, { desc = "[G]it: [A]dd" })

    -- for fugitive:
    { "gh",          ":diffget //2<CR>", desc = "fugitive split: [G]et left(2)" },
    { "gj",          ":diffget //3<CR>", desc = "fugitive split: [G]et down(3)" },
    { "gk",          ":diffget //2<CR>", desc = "fugitive split: [G]et up(2)" },
    { "gl",          ":diffget //3<CR>", desc = "fugitive split: [G]et right(3)" },
}

return { -- Git Ui
    "tpope/vim-fugitive",
    keys = keys,
}
