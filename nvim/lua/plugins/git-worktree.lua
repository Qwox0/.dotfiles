-- <https://github.com/ThePrimeagen/git-worktree.nvim>



local keys = {
    {
        "<leader>gc",
        function()
            require("telescope").extensions.git_worktree.git_worktrees()
        end,
        desc = "[G]it worktree [C]heckout"
    },
    {
        "<leader>gn",
        function()
            require("telescope").extensions.git_worktree.create_git_worktree()
        end,
        desc = "[G]it worktree [N]ew"
    },
}

local function config()
    local git_wt = require("git-worktree")

    git_wt.setup {
        --- The vim command used to change to the new worktree directory. Set this to tcd if you want to only change the pwd for the current vim Tab.
        --- default: "cd",
        change_directory_command = "cd",
        --- Updates the current buffer to point to the new work tree if the file is found in the new project. Otherwise, the following command will be run.
        --- default: true
        update_on_change = true,
        --- The vim command to run during the update_on_change event. Note, that this command will only be run when the current file is not found in the new worktree. This option defaults to e . which opens the root directory of the new worktree.
        --- default: "e .",
        update_on_change_command = "e .",
        --- Every time you switch branches, your jumplist will be cleared so that you don't accidentally go backward to a different branch and edit the wrong files.
        --- default: true,
        clearjumps_on_change = true,
        --- When creating a new worktree, it will push the branch to the upstream then perform a git rebase
        --- default: false,
        autopush = false,
    }

    git_wt.on_tree_change(function(op, metadata)
        if op == git_wt.Operations.Switch then
            print("Switched from `" .. metadata.prev_path .. "` to `" .. metadata.path .. "`")
        end
    end)

    require("telescope").load_extension("git_worktree")
end




return {
    "theprimeagen/git-worktree.nvim",
    dependencies = {
        "nvim-telescope/telescope.nvim",
    },
    keys = keys,
    config = config,
}
