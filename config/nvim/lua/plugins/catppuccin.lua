return {
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000,
	config = function()
		require("catppuccin").setup({
			transparent_background = true,
			integrations = {
				neotree = true,
				telescope = { enable = true },
				which_key = true,
			},
		})
		vim.cmd.colorscheme("catppuccin")
	end,
}
