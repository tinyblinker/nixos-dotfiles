return {
	"flash.nvim",
	for_cat = "general",
	on_require = { "flash" },
	keys = {
		{ "s", mode = { "n", "v" }, function() require("flash").jump() end, desc = "Flash" },
	},
	after = function()
		require("flash").setup({})
	end,
}
