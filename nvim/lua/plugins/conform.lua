return {
	"stevearc/conform.nvim",
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
			-- there are fucking mass in code in dwm
			--			c = { "clang-format" },
			--      cpp = { "clang-format" },
			sh = { "shellharden" },
			rust = { "rustfmt" },
			nix = { "nixfmt" },
			python = { "black" },
		},
		format_on_save = {
			lsp_format = "never",
			timeout_ms = 4000,
		},
	},
}
