return {
	"folke/tokyonight.nvim",
	priority = 1000, -- Make sure to load this before all the other start plugins.
	config = function()
		---@diagnostic disable-next-line: missing-fields
		require("tokyonight").setup({
			styles = {
				comments = { italic = false }, -- Disable italics in comments
			},
		})

		-- 开启主题,tokyonight-night
		vim.cmd.colorscheme("tokyonight-night")
	end,
}
