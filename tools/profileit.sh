#!/bin/bash
# Using bash due its array support, which can conveniently declare benchmarks
set -eu

EMPTY="empty.txt"
# a fairly large and infrequently modified file
LUAFILE="/home/doom/.config/nvim/lua/colors/doom-one/init.lua"
VIM=("nvim" "--headless")


function bench() {
    SCENARIO_NAME="${1}"
    shift
    OLD=("${NVIM_OLD[@]}" "$@")
    NEW=("${NVIM_NEW[@]}" "$@")
    vim-profiler/vim-profiler.py -r 10 -s "${OLD[@]}"
    vim-profiler/vim-profiler.py -r 10 -s "${NEW[@]}"
    hyperfine --export-markdown comparison.md --warmup 3 \
              -n "${SCENARIO_NAME} old" \
              "${OLD[*]@Q}" \
              -n "${SCENARIO_NAME} new" \
              "${NEW[*]@Q}"
    cat comparison.md >>workspace/all_comparison.md
}

# Prepare tools
test -d vim-profiler \
    || git clone --depth=1 https://github.com/bchretien/vim-profiler.git

rm -f "${EMPTY}"

# install all parsers even if not used, most reliable way to ensure
# parsers aren't being installed during profiling
# this is slow because parsers are installed sequentially
FINISH_INSTALL0=(
    --cmd 'autocmd User PackerComplete quitall'
    --cmd 'autocmd User DoomStarted PackerSync'
)

FINISH_INSTALL1=(
    -c "TSInstallSync! lua"
    -c "quitall"
)

NVIM_OLD=("env" "HOME=${1}" "${VIM[@]}")
NVIM_NEW=("env" "HOME=${2}" "${VIM[@]}")

echo
echo "Finishing install"
echo
# Note: this will hang if packer is not used
# TODO: put this into separate script
rm -f ${1}/.local/share/nvim/plugin/packer_compiled.lua
rm -f ${2}/.local/share/nvim/plugin/packer_compiled.lua
"${NVIM_OLD[@]}" "${FINISH_INSTALL0[@]}"
"${NVIM_NEW[@]}" "${FINISH_INSTALL0[@]}"
"${NVIM_OLD[@]}" "${FINISH_INSTALL1[@]}"
"${NVIM_NEW[@]}" "${FINISH_INSTALL1[@]}"

rm -f all_comparison.md

# Define benchmark scenarios
# Pure startup time isn't the only relevant metric

bench "clean" "--clean" "+qa"

#bench "default-quit" "+qa"

#bench "empty-insert" "${EMPTY}" -c ":exec ':normal ia' | :qa!"
#bench "lua-view-quit" "${LUAFILE}" -c ":exec ':normal G' | :qa"

bench "lua-insert-quit" "${LUAFILE}" -c ":exec ':normal Gia' | :qa!"

# cp ${LUAFILE} l0.lua
# for i in $(seq 0 7); do
#     cat "l${i}.lua" "l${i}.lua" >"l$(($i + 1)).lua"
# done
# wc -l *.lua
# hyperfine --parameter-scan i 1 7 \
#     -n "edit file {i}" "${NVIM_NEW[*]@Q} l{i}.lua -c \":exec ':normal Gia'| :qa!\""
