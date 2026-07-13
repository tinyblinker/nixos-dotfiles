return {
	"saghen/blink.cmp",
	event = "VimEnter",
	version = "1.*",
	-- optional: provides snippets for the snippet source
	dependencies = {
		-- Snippet Engine
		{
			"L3MON4D3/LuaSnip",
			version = "2.*",
			build = "make install_jsregexp",
			dependencies = {
				{
					"rafamadriz/friendly-snippets",
					config = function()
						require("luasnip.loaders.from_vscode").lazy_load()
					end,
				},
			},
			opts = {},
		},
		"onsails/lspkind.nvim",
	},

	-- 防止opts中的sources.default被覆盖默认配置
	opts_extend = { "sources.default" },
	---@module 'blink.cmp'
	---@type blink.cmp.Config
	opts = {
		-- NOTE:关键点:设定keymap为default映射
		keymap = {
			-- 'default' (recommended) for mappings similar to built-in completions
			--   <c-y> to accept ([y]es) the completion.
			-- 'super-tab' for tab to accept
			-- 'enter' for enter to accept
			-- 'none' for no mappings
			-- All presets have the following mappings:
			-- <tab>/<s-tab>: move to right/left of your snippet expansion
			-- <c-space>: Open menu or open docs if already open
			-- <c-n>/<c-p> or <up>/<down>: Select next/previous item
			-- <c-e>: Hide menu
			-- <c-k>: Toggle signature help
			preset = "default",
		},
		appearance = {
			nerd_font_variant = "mono",
		},
		-- 显示文档
		completion = {
			documentation = { auto_show = false, auto_show_delay_ms = 500 },
			menu = {
				draw = {
					components = {
						kind_icon = {
							text = function(ctx)
								return require("lspkind").symbol_map[ctx.kind] or ""
							end,
						},
					},
				},
			},
		},
		-- 补全来源
		sources = {
			default = { "lsp", "path", "snippets", "buffer" },
		},
		snippets = { preset = "luasnip" },
		-- 排序方法
		fuzzy = { implementation = "prefer_rust_with_warning" },
		-- 显示签名
		signature = { enabled = true },
	},
	config = function(_, opts)
		require("blink.cmp").setup(opts)
	end,
}
