#!/usr/bin/env bash
set -eu -o pipefail

# Get directory of script, see start_docker.sh
SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

REV_OLD=$(cd "${SCRIPT_DIR}/doom-nvim-contrib" && git rev-parse 'HEAD~1')
REV_NEW=$(cd "${SCRIPT_DIR}/doom-nvim-contrib" && git rev-parse 'HEAD')

echo "Comparing old commit:"
git log --format=oneline -1 "${REV_OLD}"

echo "With new commit:"
git log --format=oneline -1 "${REV_NEW}"

function worktree_prepare() {
    DIR="${1}"
    REV="${2}"
    WORKTREE="${DIR}/.config/nvim"
    if [ -d "${WORKTREE}" ]; then
        (cd "${WORKTREE}" && git reset --hard "${REV}")
    else
        git worktree add "${WORKTREE}" --detach "${REV}"
    fi

    rm "${DIR}/.cache/nvim" -rf
    mkdir -p "${DIR}/.local/share/nvim"
}

worktree_prepare "${SCRIPT_DIR}/compare_old" "${REV_OLD}"
worktree_prepare "${SCRIPT_DIR}/compare_new" "${REV_NEW}"

DOOM_OLD=/home/doom/compare_old
DOOM_NEW=/home/doom/compare_new

./start_docker.sh  -- \
    -v "${SCRIPT_DIR}/compare_old":${DOOM_OLD}:Z \
    -v "${SCRIPT_DIR}/compare_new":${DOOM_NEW}:Z \
    -v "${SCRIPT_DIR}/:/home/doom/script":ro,Z \
    --entrypoint "[\"/home/doom/script/profileit.sh\", \"${DOOM_OLD}\", \"${DOOM_NEW}\"]"
