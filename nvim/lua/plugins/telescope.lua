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

		-- pcall是lua的安全调用函数(Protected Call).即使没有安装telescope-fzf-native.nvim,也会忽略报错
		--
		-- 尝试加载fzf扩展用于telescope搜索引擎加速
		pcall(require("telescope").load_extension, "fzf")

		-- 设置当前缓冲区模糊搜索快捷键
		vim.keymap.set("n", "<leader>/", function()
			builtin.current_buffer_fuzzy_find()
		end, { desc = "Fuzzy search current buffer" })
		-- 搜索 Neovim 帮助文档
		vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
		-- 搜索当前所有快捷键
		vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
		-- 搜索文件名（最常用）
		vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
		-- 列出 Telescope 所有可用的搜索命令
		vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
		-- 在项目中搜索光标下的单词（支持全局和可视化模式）
		vim.keymap.set({ "n", "v" }, "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
		-- 在全项目中进行文本内容搜索（实时 Grep）
		vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
		-- 搜索 LSP 代码诊断错误/警告
		vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
		-- 恢复上一次的搜索状态/历史
		vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
		-- 搜索最近打开的文件
		vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
		-- 双击 leader 键快速切换当前打开的缓冲区（文件）
		vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })

		-- 创建一个用于处理LSP的自动命令组
		vim.api.nvim_create_autocmd("LspAttach", {
			-- 创建一个自动命令组,clear = true 确保重新加载配置时不会重新绑定
			group = vim.api.nvim_create_augroup("telescope-lsp-attach", { clear = true }),
			callback = function(event)
				local buf = event.buf -- 获取当前触发事件的缓冲区ID

				-- 将以下快捷键限定在当前的 buffer 中：
				--
				-- 查找所有引用该变量/函数的地方
				vim.keymap.set("n", "grr", builtin.lsp_references, { buffer = buf, desc = "[G]oto [R]eferences" })
				-- 跳转到接口的具体实现
				vim.keymap.set(
					"n",
					"gri",
					builtin.lsp_implementations,
					{ buffer = buf, desc = "[G]oto [I]mplementation" }
				)
				-- 跳转到定义处
				vim.keymap.set("n", "grd", builtin.lsp_definitions, { buffer = buf, desc = "[G]oto [D]efinition" })
				-- 模糊搜索当前文件内的所有符号（函数名、变量名）
				vim.keymap.set(
					"n",
					"gO",
					builtin.lsp_document_symbols,
					{ buffer = buf, desc = "Open Document Symbols" }
				)
				-- 全项目模糊搜索符号
				vim.keymap.set(
					"n",
					"gW",
					builtin.lsp_dynamic_workspace_symbols,
					{ buffer = buf, desc = "Open Workspace Symbols" }
				)
				-- 跳转到类型定义处
				vim.keymap.set(
					"n",
					"grt",
					builtin.lsp_type_definitions,
					{ buffer = buf, desc = "[G]oto [T]ype Definition" }
				)
			end,
		})

		-- 快捷键：<leader>s/
		-- 效果：限制只在“当前已经打开的所有文件（Open Files）”里进行 Grep 文本搜索，而不是整个项目。
		vim.keymap.set("n", "<leader>s/", function()
			builtin.live_grep({
				grep_open_files = true,
				prompt_title = "Live Grep in Open Files",
			})
		end, { desc = "[S]earch [/] in Open Files" })

		-- 快捷键：<leader>sn
		-- 效果：快速搜索和打开 Neovim 自身的配置文件。stdpath("config") 会自动指向你的 ~/.config/nvim 目录。
		vim.keymap.set("n", "<leader>sn", function()
			builtin.find_files({ cwd = vim.fn.stdpath("config") })
		end, { desc = "[S]earch [N]eovim files" })
	end,
}
