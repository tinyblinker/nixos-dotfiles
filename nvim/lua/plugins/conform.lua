return {
	"conform.nvim",
	for_cat = "format",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	on_require = { "conform" },
	after = function()
		require("conform").setup({
			formatters_by_ft = {
				lua = { "stylua" },
				sh = { "shellharden" },
				rust = { "rustfmt" },
				nix = { "nixfmt" },
				python = { "black" },
			},
			format_on_save = {
				lsp_format = "never",
				timeout_ms = 4000,
			},
		})
	end,
}
