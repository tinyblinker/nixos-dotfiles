return {
	"nvim-treesitter",
	for_cat = "general",
	-- 开机加载(lazy=false),因为需要尽早为已打开的文件启用高亮
	lazy = false,
	after = function()
		-- 语法高亮由 nix 提供的 grammar(withAllGrammars)驱动
		-- 对所有拥有 parser 的 filetype 启用 treesitter
		vim.api.nvim_create_autocmd("FileType", {
			callback = function(args)
				local ft = args.match
				local lang = vim.treesitter.language.get_lang(ft)
				if lang and vim.treesitter.language.add(lang) then
					vim.treesitter.start(args.buf, lang)
					vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				end
			end,
		})
	end,
}
