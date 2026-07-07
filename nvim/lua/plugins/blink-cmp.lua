return {
	"blink.cmp",
	for_cat = "general",
	event = "DeferredUIEnter",
	-- luasnip / friendly-snippets 由 nix 单独提供,加载 blink 时一并 packadd
	load = function(name)
		vim.cmd.packadd("luasnip")
		vim.cmd.packadd("friendly-snippets")
		vim.cmd.packadd(name)
	end,
	after = function()
		require("luasnip.loaders.from_vscode").lazy_load()
		require("blink.cmp").setup({
			keymap = { preset = "default" },
			appearance = { nerd_font_variant = "mono" },
			completion = {
				documentation = { auto_show = false, auto_show_delay_ms = 500 },
			},
			sources = {
				default = { "lsp", "path", "snippets", "buffer" },
			},
			snippets = { preset = "luasnip" },
			fuzzy = { implementation = "prefer_rust_with_warning" },
			signature = { enabled = true },
		})
	end,
}
