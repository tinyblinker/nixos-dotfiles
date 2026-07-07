return {
	"todo-comments.nvim",
	for_cat = "general",
	event = "DeferredUIEnter",
	after = function()
		require("todo-comments").setup({})
	end,
}
