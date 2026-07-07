-- tokyonight 属于 startupPlugins(开机加载),直接配置,不走 lze 懒加载
require("plugins.tokyonight")

-- 使用 lze 加载其余插件 spec
-- 每个 plugins/*.lua 返回一个 lze spec(或 spec 列表)
require("lze").load({
	{ import = "plugins.telescope" },
	{ import = "plugins.nvim-treesitter" },
	{ import = "plugins.blink-cmp" },
	{ import = "plugins.nvim-lspconfig" },
	{ import = "plugins.lualine" },
	{ import = "plugins.gitsigns" },
	{ import = "plugins.neo-tree" },
	{ import = "plugins.which-key" },
	{ import = "plugins.flash" },
	{ import = "plugins.autopairs" },
	{ import = "plugins.indent-line" },
	{ import = "plugins.todo-comments" },
	{ import = "plugins.conform" },
	{ import = "plugins.nvim-lint" },
})
