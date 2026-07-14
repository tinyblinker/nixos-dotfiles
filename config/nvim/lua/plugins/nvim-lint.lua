return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPre", "BufNewFile" },

	config = function()
		local lint = require("lint")
		-- for cpp, use clangd --clang-tidy for real-time diagnostics; standalone clang-tidy for CI-level diagnostics
		lint.linters_by_ft = {
			sh = { "shellcheck" },
			python = { "ruff" },
			rust = { "clippy" },
			nix = { "deadnix" },
		}

		local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
			group = lint_augroup,
			callback = function()
				-- Only try lint when buffer is modifiable
				if vim.bo.modifiable then
					lint.try_lint()
				end
			end,
		})
	end,
}
