return {
	"nvim-lualine/lualine.nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	opts = {
		options = {
			theme = "tokyonight",
			component_separators = "|",
			section_separators = "|",
			globalstatus = true,
		},

		sections = {
			lualine_a = { "mode" },
			lualine_b = { "branch", "diff" },
			lualine_c = { { "filename", path = 1 } },

			lualine_x = { "diagnostics" },
			lualine_y = { "filetype" },
			lualine_z = { "location", "progress" },
		},
	},
}
