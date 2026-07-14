return {
	"nvim-neo-tree/neo-tree.nvim",
	version = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
	},
	lazy = false,
	keys = {
		{ "<leader>e", ":Neotree toggle reveal<CR>", desc = "NeoTree Toggle", silent = true },
	},
	opts = {
		window = {
			position = "left",
			width = 30,
		},
		filesystem = {
			follow_current_file = {
				enabled = true, -- Auto-locate current file (strongly recommended)
			},
			filtered_items = {
				hide_dotfiles = false, -- Don't hide dotfiles (more practical for development)
				hide_gitignored = false,
			},
		},

		default_component_configs = {
			git_status = {
				symbols = {
					added = "+ ",
					modified = "~ ",
					deleted = "- ",
					renamed = "> ",

					untracked = "? ",
					ignored = "· ",
					unstaged = "○ ",
					staged = "✓ ",
					conflict = "! ",
				},
			},
		},
	},
}
