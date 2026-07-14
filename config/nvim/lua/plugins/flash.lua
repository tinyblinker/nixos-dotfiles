return {
	"folke/flash.nvim",
	event = "VeryLazy",
	---@type Flash.Config
	opts = {},
	keys = {
		-- Register 's' for precise jump in normal and visual mode
		{
			"s",
			mode = { "n", "v" },
			function()
				require("flash").jump()
			end,
			desc = "Flash",
		},
	},
}
