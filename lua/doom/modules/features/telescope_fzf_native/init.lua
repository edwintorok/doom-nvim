local telescope_fzf_native = {}

telescope_fzf_native.settings = {}

telescope_fzf_native.packages = {
  ["telescope-fzf-native.nvim"] = {
    "nvim-telescope/telescope-fzf-native.nvim",
    commit = "2330a7eac13f9147d6fe9ce955cb99b6c1a0face",
    run = "make", -- disabled by default because it builds code
  },
}

telescope_fzf_native.configs = {}
telescope_fzf_native.configs["telescope-fzf-native.nvim"] = function()
  table.insert(doom.features.telescope.settings.extensions, "fzf")
end

return telescope_fzf_native
