--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- 让配置在无 nixCats 时也能运行,给 nixCats() 一个默认值
require("nixCatsUtils").setup({
	non_nix_value = true,
})

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = nixCats("have_nerd_font") or true

-- configs
require("config.options")
require("config.keymaps")
require("config.autocmds")

-- 注册 lze 的 for_cat handler,然后加载所有插件 spec
require("lze").register_handlers(require("nixCatsUtils.lzUtils").for_cat)
require("lze").register_handlers(require("lzextras").lsp)
require("config.plugins")

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
