vim.api.nvim_create_user_command("W", "w", { desc = "Prevent misstype of :w" })
vim.api.nvim_create_user_command("Wa", "wa", { desc = "Prevent misstype of :wa" })
vim.api.nvim_create_user_command("WA", "wa", { desc = "Prevent misstype of :wa" })
vim.api.nvim_create_user_command("Wq", "wq", { desc = "Prevent misstype of :wq" })
vim.api.nvim_create_user_command("WQ", "wq", { desc = "Prevent misstype of :wq" })
vim.api.nvim_create_user_command("Wqa", "wqa", { desc = "Prevent misstype of :wqa" })
vim.api.nvim_create_user_command("WQa", "wqa", { desc = "Prevent misstype of :wqa" })
