-- doom_config - Doom Nvim user configurations file
--
-- This file contains the user-defined configurations for Doom nvim.
-- Just override stuff in the `doom` global table (it's injected into scope
-- automatically).

doom.preserve_edit_pos = true
doom.relative_num = false
doom.impatient_enabled = true

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

opt.backupdir:remove(".") -- do not put backups into current dir

-- ADDING A PACKAGE
--
-- doom.use_package("EdenEast/nightfox.nvim", "sainnhe/sonokai")
-- doom.use_package({
--   "ur4ltz/surround.nvim",
--   config = function()
--     require("surround").setup({mappings_style = "sandwich"})
--   end
-- })

doom.use_package({
  "edwintorok/vim-ocaml",
  branch = "ocaml_interface",
  commit = "0302ed5ab6e4e3a0003ba41cfc9d39d677dc280a",
})

doom.use_package({
  "goerz/jupytext.vim",
  commit = "32c1e37b2edf63a7e38d0deb92cc3f1462cc4dcd",
  setup = function()
    vim.g.jupytext_fmt = "py"
    vim.g.ipy_celldef = "^# %%" -- regex for cell start and end
  end,
})

doom.use_package({
  "equalsraf/neovim-gui-shim",
  commit = "668188542345e682addfc816af38b7073d376a64",
  cond = function()
    return vim.fn.exists("g:GuiLoaded")
  end,
  config = function()
    vim.cmd([[
            if exists(':GuiScrollBar')
                GuiScrollBar 1
            endif

            " Right Click Context Menu (Copy-Cut-Paste)
            nnoremap <silent><RightMouse> :call GuiShowContextMenu()<CR>
            inoremap <silent><RightMouse> <Esc>:call GuiShowContextMenu()<CR>
            xnoremap <silent><RightMouse> :call GuiShowContextMenu()<CR>gv
            snoremap <silent><RightMouse> <C-G>:call GuiShowContextMenu()<CR>gv
        ]])
  end,
})
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

doom.use_keybind({
  { "<Esc>", "<C-\\><C-n>", mode = "t" }, -- from :help terminal, TODO: upstream

  {
    "<C-p>",
    name = "+search",
    function()
      if not packer_plugins["telescope.nvim"] then
        return
      end
      local b = require("telescope.builtin")
      local opts = { previewer = false }
      if vim.fn.finddir(".git", ";") == "" then
        b.find_files(opts)
      else
        b.git_files(opts)
      end
    end,
  }, -- <C-p> conflicts with Doom's, TODO: use feature toggle

  { "<leader>pc", "<C-u>make<CR>", name = "compile" },

  { "<localleader>g", name="+go", {
    { "b", "<C-O>", name = "go back" },
    { "S", ":e <cfile><.%:e<CR>", name = "create file" },
    -- from https://github.com/Hipomenes/myconfigs/blob/master/.vimrc
    -- word under cursor + extension of current file
  }},

  -- TODO: telekasten insert mode mappings!
  -- TODO: telekasten normal mode mappings!
})

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

doom.use_autocmd({
  { "FileType", "gitcommit,markdown", "setlocal spell" },
})

-- vim: sw=2 sts=2 ts=2 expandtab
