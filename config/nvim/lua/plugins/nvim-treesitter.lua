return { -- Highlight, edit, and navigate code
	"nvim-treesitter/nvim-treesitter",
	config = function()
		local filetypes = {
			"bash",
			"rust",
			"nix",
			"c",
			"rust",
			"fish",
			"diff",
			"html",
			"lua",
			"asm",
			"luadoc",
			"markdown",
			"markdown_inline",
			"query",
			"cpp",
			"cmake",
			"vim",
			"vimdoc",
			"python",
		}
		require("nvim-treesitter").install(filetypes)
		vim.api.nvim_create_autocmd("FileType", {
			pattern = filetypes,
			callback = function()
				vim.treesitter.start()
			end,
		})
	end,
}
