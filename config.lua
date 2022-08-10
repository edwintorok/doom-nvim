-- doom_config - Doom Nvim user configurations file
--
-- This file contains the user-defined configurations for Doom nvim.
-- Just override stuff in the `doom` global table (it's injected into scope
-- automatically).

doom.preserve_edit_pos = true
doom.relative_num = false
doom.impatient_enabled = true
doom.features.indentlines.settings.char = "┊"

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

doom.use_package({
  "renerocksai/telekasten.nvim",
  commit = "acc5f0e3337139a68155efb8c5c593ed4fcee600",
  cond = function()
    -- to allow sharing packer_precompiled.lua between machines delay check
    return vim.fn.executable("rg") == 1
  end,
  requires = {
    {
      "renerocksai/calendar-vim",
      commit = "a7e73e02c92566bf427b2a1d6a61a8f23542cc21",
    },
    { "nvim-telescope/telescope.nvim" },
  },
  config = function()
    local home = vim.fn.expand("~/Documents/notes")
    require("telekasten").setup({
      home = home,
      take_over_my_home = true, -- enable when opening note within
      auto_set_file_type = true, -- enable telekasten syntax
      -- dir names for special notes (absolute path or subdir name)
      dailies = home .. "/" .. "daily",
      weeklies = home .. "/" .. "weekly",
      templates = home .. "/" .. "templates",
    })
  end,
})

doom.use_package({
  "jnurmine/zenburn",
  commit = "8df765342b2a33c728ce147d6c8e66359378f9d5",
  opt = true,
})
vim.g.zenburn_high_Contrast = 1
doom.use_autocmd({
  { "ColorScheme", "zenburn", "hi Comment guifg=#aedbae" },
})
doom.colorscheme = "zenburn"

doom.use_package({
  "nvim-treesitter/playground",
  command = "TSHighlightCapturesUnderCursor",
  commit = "8a887bcf66017bd775a0fb19c9d8b7a4d6759c48",
})

doom.use_package({
  "iamcco/markdown-preview.nvim",
  commit = "02cc3874738bc0f86e4b91f09b8a0ac88aef8e96",
  run = function()
    vim.fn["mkdp#util#install"]()
  end,
})

doom.use_package({
  "dhruvasagar/vim-table-mode",
  commit = "9555a3e6e5bcf285ec181b7fc983eea90500feb4",
  config = function()
    vim.g.table_mode_corner = "|"
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

--
--  " the following are for syntax-coloring [[links]] and ==highlighted text==
--  " (see the section about coloring in README.md)
--
--  " colors suitable for gruvbox color scheme
--   hi tklink ctermfg=72 guifg=#689d6a cterm=bold,underline gui=bold,underline
--   hi tkBrackets ctermfg=gray guifg=gray
--
--   " real yellow
--   hi tkHighlight ctermbg=yellow ctermfg=darkred cterm=bold guibg=yellow guifg=darkred gui=bold
--   " gruvbox
--   "hi tkHighlight ctermbg=214 ctermfg=124 cterm=bold guibg=#fabd2f guifg=#9d0006 gui=bold
--
--   hi link CalNavi CalRuler
--   hi tkTagSep ctermfg=gray guifg=gray
--   hi tkTag ctermfg=175 guifg=#d3869B
  --
  {'<leader>#', [[<cmd>lua require('telekasten').show_tags()<CR>]], 'show tags'},
  {"<leader>n", name="+telekasten", {
    {"f",   [[<cmd>lua require('telekasten').find_notes()<CR>]], name='find notes' },
    {"d",   [[<cmd>lua require('telekasten').find_daily_notes()<CR>]], name='find daily notes' },
    {"g",   [[<cmd>lua require('telekasten').search_notes()<CR>]], name='search notes' },
    {"z",   [[<cmd>lua require('telekasten').follow_link()<CR>]], name='follow link' },
    {"T",   [[<cmd>lua require('telekasten').goto_today()<CR>]], name='go to today' },
    {"W",   [[<cmd>lua require('telekasten').goto_thisweek()<CR>]], name='go to this week' },
    {"w",   [[<cmd>lua require('telekasten').find_weekly_notes()<CR>]], name='find weekly notes' },
    {"n",   [[<cmd>lua require('telekasten').new_note()<CR>]], name='new note' },
    {"N",   [[<cmd>lua require('telekasten').new_templated_note()<CR>]], name='new templated note' },
    {"y",   [[<cmd>lua require('telekasten').yank_notelink()<CR>]], name='yank note link' },
    {"c",   [[<cmd>lua require('telekasten').show_calendar()<CR>]], name='show calendar' },
    {"C",  "CalendarT", name='show full-screen calendar' },
    {"i",   [[<cmd>lua require('telekasten').paste_img_and_link()<CR>]], name='paste image and link' },
    {"t",   [[<cmd>lua require('telekasten').toggle_todo()<CR>]], name='toggle todo' },
    {"b",   [[<cmd>lua require('telekasten').show_backlinks()<CR>]], name='show backlinks' },
    {"F",   [[<cmd>lua require('telekasten').find_friends()<CR>]], name='find friends' },
    {"I",   [[<cmd>lua require('telekasten').insert_img_link({ i = true })<CR>]], name='insert image link' },
    {"p",   [[<cmd>lua require('telekasten').preview_img()<CR>]], name='preview image' },
    {"m",   [[<cmd>lua require('telekasten').browse_media()<CR>]], name='browse media' },
    {"a",   [[<cmd>lua require('telekasten').show_tags()<CR>]], name='show tags' },
    {"r",   [[<cmd>lua require('telekasten').rename_note()<CR>]], name='rename note' },
  }},
  {mode="i",{
    {"<leader>[", [[<cmd>lua require('telekasten').insert_link({ i=true })<CR>]]},
    {"<leader>nt", [[<cmd>lua require('telekasten').toggle_todo({ i=true })<CR>]]},
    {"<leader>#",  [[<cmd>lua require('telekasten').show_tags({i = true})<CR>]]}
  }},
  {mode="v",{
    {"<leader>nt", [[<cmd>lua require('telekasten').toggle_todo({ v = true })<CR>]]}
  }},
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
