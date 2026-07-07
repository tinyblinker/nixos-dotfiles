return {
	"neo-tree.nvim",
	for_cat = "general",
	cmd = { "Neotree" },
	on_require = { "neo-tree" },
	-- nui/plenary/web-devicons 由 nix 提供,加载时一并 packadd
	load = function(name)
		vim.cmd.packadd("nui.nvim")
		vim.cmd.packadd("nvim-web-devicons")
		vim.cmd.packadd(name)
	end,
	keys = {
		{ "<leader>e", ":Neotree toggle reveal<CR>", desc = "NeoTree Toggle", silent = true },
	},
	after = function()
		require("neo-tree").setup({
			window = {
				position = "left",
				width = 30,
			},
			filesystem = {
				follow_current_file = {
					enabled = true,
				},
				filtered_items = {
					hide_dotfiles = false,
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
		})
	end,
}
