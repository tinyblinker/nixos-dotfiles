return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPre", "BufNewFile" },

	config = function()
		local lint = require("lint")
		-- for cpp, use the clangd --clang-tidy for 及时的诊断,独立运行clang-tidy用于CI级别的诊断
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
				-- 当缓冲区可更改时再尝试lint
				if vim.bo.modifiable then
					lint.try_lint()
				end
			end,
		})
	end,
}
