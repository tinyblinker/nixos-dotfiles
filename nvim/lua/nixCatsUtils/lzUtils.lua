-- nixCatsUtils.lzUtils: 一个 nixCats 专用的 lze handler
-- 通过 for_cat 字段,可根据分类是否启用来条件加载插件
-- 用法:require('lze').register_handlers(require('nixCatsUtils.lzUtils').for_cat)
-- 支持:
--   for_cat = "your.cat";
--   for_cat = { cat = "your.cat", default = bool };  -- default 为非 nix 环境下的取值
local M = {}

M.for_cat = {
  spec_field = "for_cat",
  set_lazy = false,
  modify = function(plugin)
    if type(plugin.for_cat) == "table" and plugin.for_cat.cat ~= nil then
      if vim.g[ [[nixCats-special-rtp-entry-nixCats]] ] ~= nil then
        plugin.enabled = nixCats(plugin.for_cat.cat) or false
      else
        plugin.enabled = plugin.for_cat.default
      end
    else
      plugin.enabled = nixCats(plugin.for_cat) or false
    end
    return plugin
  end,
}

return M
