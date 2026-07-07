return {
	"telescope.nvim",
	for_cat = "general",
	cmd = { "Telescope" },
	on_require = { "telescope" },
	event = "DeferredUIEnter",
	-- 加载 telescope 时一并 packadd fzf-native
	load = function(name)
		vim.cmd.packadd(name)
		vim.cmd.packadd("telescope-fzf-native.nvim")
	end,
	keys = {
		{ "<leader>/", function() require("telescope.builtin").current_buffer_fuzzy_find() end, mode = "n", desc = "Fuzzy search current buffer" },
		{ "<leader>sh", function() require("telescope.builtin").help_tags() end, mode = "n", desc = "[S]earch [H]elp" },
		{ "<leader>sk", function() require("telescope.builtin").keymaps() end, mode = "n", desc = "[S]earch [K]eymaps" },
		{ "<leader>sf", function() require("telescope.builtin").find_files() end, mode = "n", desc = "[S]earch [F]iles" },
		{ "<leader>ss", function() require("telescope.builtin").builtin() end, mode = "n", desc = "[S]earch [S]elect Telescope" },
		{ "<leader>sw", function() require("telescope.builtin").grep_string() end, mode = { "n", "v" }, desc = "[S]earch current [W]ord" },
		{ "<leader>sg", function() require("telescope.builtin").live_grep() end, mode = "n", desc = "[S]earch by [G]rep" },
		{ "<leader>sd", function() require("telescope.builtin").diagnostics() end, mode = "n", desc = "[S]earch [D]iagnostics" },
		{ "<leader>sr", function() require("telescope.builtin").resume() end, mode = "n", desc = "[S]earch [R]esume" },
		{ "<leader>s.", function() require("telescope.builtin").oldfiles() end, mode = "n", desc = '[S]earch Recent Files ("." for repeat)' },
		{ "<leader><leader>", function() require("telescope.builtin").buffers() end, mode = "n", desc = "[ ] Find existing buffers" },
		{ "<leader>s/", function()
			require("telescope.builtin").live_grep({ grep_open_files = true, prompt_title = "Live Grep in Open Files" })
		end, mode = "n", desc = "[S]earch [/] in Open Files" },
		{ "<leader>sn", function()
			require("telescope.builtin").find_files({ cwd = vim.fn.stdpath("config") })
		end, mode = "n", desc = "[S]earch [N]eovim files" },
	},
	after = function()
		require("telescope").setup({})
		pcall(require("telescope").load_extension, "fzf")

		-- LSP 相关的 telescope 键位,在 LspAttach 时绑定到当前 buffer
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("telescope-lsp-attach", { clear = true }),
			callback = function(event)
				local buf = event.buf
				local builtin = require("telescope.builtin")
				vim.keymap.set("n", "grr", builtin.lsp_references, { buffer = buf, desc = "[G]oto [R]eferences" })
				vim.keymap.set("n", "gri", builtin.lsp_implementations, { buffer = buf, desc = "[G]oto [I]mplementation" })
				vim.keymap.set("n", "grd", builtin.lsp_definitions, { buffer = buf, desc = "[G]oto [D]efinition" })
				vim.keymap.set("n", "gO", builtin.lsp_document_symbols, { buffer = buf, desc = "Open Document Symbols" })
				vim.keymap.set("n", "gW", builtin.lsp_dynamic_workspace_symbols, { buffer = buf, desc = "Open Workspace Symbols" })
				vim.keymap.set("n", "grt", builtin.lsp_type_definitions, { buffer = buf, desc = "[G]oto [T]ype Definition" })
			end,
		})
	end,
}
