return {
	"indent-blankline.nvim",
	for_cat = "general",
	event = "DeferredUIEnter",
	after = function()
		require("ibl").setup({})
	end,
}
