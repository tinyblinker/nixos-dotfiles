return {
	"nvim-telescope/telescope.nvim",
	version = "*",
	event = "VimEnter",
	dependencies = {
		"nvim-lua/plenary.nvim",
		-- optional but recommended
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make",
			cond = function()
				return vim.fn.executable("make") == 1
			end,
		},
	},
	config = function()
		local builtin = require("telescope.builtin")

		-- pcall is Lua's protected call. Errors are silently ignored even if telescope-fzf-native.nvim is not installed.
		--
		-- Try to load fzf extension to speed up telescope search
		pcall(require("telescope").load_extension, "fzf")

		-- Set fuzzy search keymap for current buffer
		vim.keymap.set("n", "<leader>/", function()
			builtin.current_buffer_fuzzy_find()
		end, { desc = "Fuzzy search current buffer" })
		-- Search Neovim help docs
		vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
		-- Search all current keymaps
		vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
		-- Search filenames (most used)
		vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
		-- List all available Telescope commands
		vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
		-- Search for word under cursor in project (supports normal and visual mode)
		vim.keymap.set({ "n", "v" }, "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
		-- Full-project live grep search
		vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
		-- Search LSP diagnostics
		vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
		-- Resume last search session
		vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
		-- Search recently opened files
		vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
		-- Double-tap leader to switch open buffers
		vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })

		-- Create autocmd group for LSP handling
		vim.api.nvim_create_autocmd("LspAttach", {
			-- Create autocmd group; clear = true prevents duplicate bindings on reload
			group = vim.api.nvim_create_augroup("telescope-lsp-attach", { clear = true }),
			callback = function(event)
				local buf = event.buf -- Get the buffer ID that triggered the event

				-- Buffer-local keymaps:
				--
				-- Find all references to this variable/function
				vim.keymap.set("n", "grr", builtin.lsp_references, { buffer = buf, desc = "[G]oto [R]eferences" })
				-- Jump to interface implementations
				vim.keymap.set(
					"n",
					"gri",
					builtin.lsp_implementations,
					{ buffer = buf, desc = "[G]oto [I]mplementation" }
				)
				-- Jump to definition
				vim.keymap.set("n", "grd", builtin.lsp_definitions, { buffer = buf, desc = "[G]oto [D]efinition" })
				-- Fuzzy search symbols in current file
				vim.keymap.set(
					"n",
					"gO",
					builtin.lsp_document_symbols,
					{ buffer = buf, desc = "Open Document Symbols" }
				)
				-- Fuzzy search symbols across workspace
				vim.keymap.set(
					"n",
					"gW",
					builtin.lsp_dynamic_workspace_symbols,
					{ buffer = buf, desc = "Open Workspace Symbols" }
				)
				-- Jump to type definition
				vim.keymap.set(
					"n",
					"grt",
					builtin.lsp_type_definitions,
					{ buffer = buf, desc = "[G]oto [T]ype Definition" }
				)
			end,
		})

		-- Keymap: <leader>s/
		-- Effect: Grep only in currently open files, not the whole project.
		vim.keymap.set("n", "<leader>s/", function()
			builtin.live_grep({
				grep_open_files = true,
				prompt_title = "Live Grep in Open Files",
			})
		end, { desc = "[S]earch [/] in Open Files" })

		-- Keymap: <leader>sn
		-- Effect: Quick search and open Neovim config files. stdpath("config") points to your ~/.config/nvim directory.
		vim.keymap.set("n", "<leader>sn", function()
			builtin.find_files({ cwd = vim.fn.stdpath("config") })
		end, { desc = "[S]earch [N]eovim files" })
	end,
}
