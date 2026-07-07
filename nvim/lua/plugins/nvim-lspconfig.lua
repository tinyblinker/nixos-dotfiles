-- LSP 配置:使用 lzextras 的 lsp handler,按 filetype 懒加载
-- nixCats 提供插件路径,比扫描 rtp 更快
local ft_fallback = require("lze").h.lsp.get_ft_fallback()
require("lze").h.lsp.set_ft_fallback(function(name)
	local lspcfg = nixCats.pawsible({ "allPlugins", "opt", "nvim-lspconfig" })
		or nixCats.pawsible({ "allPlugins", "start", "nvim-lspconfig" })
	if lspcfg then
		local ok, cfg = pcall(dofile, lspcfg .. "/lsp/" .. name .. ".lua")
		if not ok then
			ok, cfg = pcall(dofile, lspcfg .. "/lua/lspconfig/configs/" .. name .. ".lua")
		end
		return (ok and cfg or {}).filetypes or {}
	else
		return ft_fallback(name)
	end
end)

-- LspAttach:通用键位、光标高亮、inlay hint 开关
local function on_attach(client, bufnr)
	local map = function(keys, func, desc, mode)
		mode = mode or "n"
		vim.keymap.set(mode, keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
	end
	map("grn", vim.lsp.buf.rename, "[R]e[n]ame")
	map("gra", vim.lsp.buf.code_action, "[G]oto Code [A]ction", { "n", "x" })
	map("grD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

	if client and client:supports_method("textDocument/documentHighlight", bufnr) then
		local hl_group = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
		vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
			buffer = bufnr,
			group = hl_group,
			callback = vim.lsp.buf.document_highlight,
		})
		vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
			buffer = bufnr,
			group = hl_group,
			callback = vim.lsp.buf.clear_references,
		})
	end
	if client and client:supports_method("textDocument/inlayHint", bufnr) then
		map("<leader>th", function()
			vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }))
		end, "[T]oggle Inlay [H]ints")
	end
end

return {
	{
		"nvim-lspconfig",
		for_cat = "general",
		on_require = { "lspconfig" },
		-- 每个含 lsp 表的 spec 在其 filetype 触发时,调用此函数
		lsp = function(plugin)
			vim.lsp.config(plugin.name, plugin.lsp or {})
			vim.lsp.enable(plugin.name)
		end,
		before = function(_)
			-- 全局默认:on_attach + blink.cmp 能力集
			local caps = vim.lsp.protocol.make_client_capabilities()
			local ok, blink = pcall(require, "blink.cmp")
			if ok then
				caps = blink.get_lsp_capabilities(caps)
			end
			vim.lsp.config("*", {
				capabilities = caps,
				on_attach = on_attach,
			})
		end,
	},
	{
		"clangd",
		enabled = nixCats("c") or false,
		lsp = {
			filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
			cmd = { "clangd", "--background-index", "--clang-tidy" },
		},
	},
	{
		"pyright",
		enabled = nixCats("python") or false,
		lsp = { filetypes = { "python" } },
	},
	{
		"rust_analyzer",
		enabled = nixCats("rust") or false,
		lsp = { filetypes = { "rust" } },
	},
	{
		"nixd",
		enabled = nixCats("nix") or false,
		lsp = {
			filetypes = { "nix" },
			settings = {
				nixd = {
					nixpkgs = {
						expr = nixCats.extra("nixdExtras.nixpkgs") or [[import <nixpkgs> {}]],
					},
					options = {
						nixos = { expr = nixCats.extra("nixdExtras.nixos_options") },
						["home-manager"] = { expr = nixCats.extra("nixdExtras.home_manager_options") },
					},
					formatting = { command = { "nixfmt" } },
				},
			},
		},
	},
	{
		"lua_ls",
		enabled = nixCats("lua") or false,
		lsp = {
			filetypes = { "lua" },
			settings = {
				Lua = {
					runtime = { version = "LuaJIT" },
					workspace = { checkThirdParty = false },
					diagnostics = { globals = { "nixCats", "vim" } },
					telemetry = { enabled = false },
				},
			},
		},
	},
}
