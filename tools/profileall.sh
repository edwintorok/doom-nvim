#!/bin/sh
set -eu
nvim --headless \
    --cmd 'packadd plenary.nvim' \
    --cmd "lua require('plenary.profile').start('profile.log', {flame=true})" \
    --cmd "autocmd VimLeave * lua require('plenary.profile').stop()" \
    +qa
inferno-flamegraph profile.log >|flame.svg

nvim --headless \
    --cmd 'profile start profile-vimscript.log' \
    --cmd 'profile file *' \
    --cmd 'profile func *' \
    +qa

perf record -F 1007 --call-graph=dwarf nvim --headless +qa
perf script | inferno-collapse-perf | inferno-flamegraph >flame2.svg
