return {
	"folke/flash.nvim",
	event = "VeryLazy",
	---@type Flash.Config
	opts = {},
	keys = {
		-- 注册normal和visual模式下支持按下's'输入精准跳转
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
