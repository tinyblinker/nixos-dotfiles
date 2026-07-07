return {
	"nvim-autopairs",
	for_cat = "general",
	event = "InsertEnter",
	after = function()
		require("nvim-autopairs").setup({})
	end,
}
