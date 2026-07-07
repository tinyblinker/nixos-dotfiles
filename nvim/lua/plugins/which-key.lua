return {
	"which-key.nvim",
	for_cat = "general",
	event = "DeferredUIEnter",
	after = function()
		require("which-key").setup({
			delay = 0,
			icons = { mappings = vim.g.have_nerd_font },
			spec = {
				{ "<leader>s", group = "[S]earch", mode = { "n", "v" } },
				{ "<leader>t", group = "[T]oggle" },
				{ "<leader>h", group = "Git [H]unk", mode = { "n", "v" } },
			},
		})
	end,
}
