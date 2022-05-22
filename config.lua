-- doom_config - Doom Nvim user configurations file
--
-- This file contains the user-defined configurations for Doom nvim.
-- Just override stuff in the `doom` global table (it's injected into scope
-- automatically).

doom.preserve_edit_pos = true
doom.relative_num = false

local o = vim.o
local opt = vim.opt
local g = vim.g

opt.guifont = "GoMono Nerd Font:h19"

g.maplocalleader = ","

o.modeline = false
-- disabled for security reasons, Neovim 0.7 only has sandbox denylist
-- i.e. it is not secure as a comment in previous Doom version claimed

o.backup = true -- by default doom only sets undofile

o.hlsearch = false -- do not set persistent highlight on search

o.ignorecase = true -- Case insensitive searching
o.smartcase = true -- if /C or capital present then case sensitive

o.spelllang = "en_gb" -- UK variant for spelling

o.report = 0 -- always show number of lines changed
o.synmaxcol = 200 -- perf: limit syntax highlighting on very long lines
o.icm = "split" -- live search&replace
o.lazyredraw = true -- reduces flicker
o.list = true -- make tabs visible

opt.listchars = {
  tab = "␉·",
  trail = "␠",
  precedes = "<",
  extends = "…",
  nbsp = "⍽",
}

-- ADDING A PACKAGE
--
-- doom.use_package("EdenEast/nightfox.nvim", "sainnhe/sonokai")
-- doom.use_package({
--   "ur4ltz/surround.nvim",
--   config = function()
--     require("surround").setup({mappings_style = "sandwich"})
--   end
-- })

-- ADDING A KEYBIND
--
-- doom.use_keybind({
--   -- The `name` field will add the keybind to whichkey
--   {"<leader>s", name = '+search', {
--     -- Bind to a vim command
--     {"g", "Telescope grep_string<CR>", name = "Grep project"},
--     -- Or to a lua function
--     {"p", function()
--       print("Not implemented yet")
--     end, name = ""}
--   }}
-- })

-- ADDING A COMMAND
--
-- doom.use_cmd({
--   {"CustomCommand1", function() print("Trigger my custom command 1") end},
--   {"CustomCommand2", function() print("Trigger my custom command 2") end}
-- })

-- ADDING AN AUTOCOMMAND
--
-- doom.use_autocmd({
--   { "FileType", "javascript", function() print('This is a javascript file') end }
-- })

-- vim: sw=2 sts=2 ts=2 expandtab
