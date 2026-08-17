-- This file contains general-purpose keymaps that belong to Neovim itself.
-- Plugin-specific mappings stay in the plugin files under lua/plugins/.

-- `vim.keymap.set` creates a key mapping.
-- We store the function in a local variable so the mapping calls below stay readable.
local map = vim.keymap.set

-- In Visual mode, ordinary `p` replaces the selection and yanks the replaced text.
-- That would overwrite the unnamed register containing the text we wanted to paste.
-- `"_d` deletes the selection into Neovim's black-hole register instead.
-- `P` then puts the original unnamed-register contents before the cursor.
-- Normal-mode `p` is unchanged because it does not replace a selection.
-- The mode string `"x"` means Visual mode only; it does not refer to the `x` key.
map("x", "p", '"_dP', { desc = "Paste without overwriting register" })

-- `<Esc>` is the Escape key.
-- `<cmd>...<CR>` runs a command-line command without opening the command line visibly.
-- In Normal mode, pressing Escape now saves the current buffer.
map("n", "<Esc>", "<cmd>write<CR>", { desc = "Save buffer" })

-- In Insert mode, the first `<Esc>` leaves Insert mode and the second command saves.
map("i", "<Esc>", "<Esc><cmd>write<CR>", { desc = "Leave Insert mode and save" })
