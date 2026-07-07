-- tokyonight 开机加载,直接 setup 并设定 colorscheme
---@diagnostic disable-next-line: missing-fields
require("tokyonight").setup({
	transparent = true,
	styles = {
		comments = { italic = false },
	},
})

vim.cmd.colorscheme("tokyonight-night")
