#!/usr/bin/env bash

# ensure directories
DOT_FILES_DIR=~/Documents/dot-files

(cd "$DOT_FILES_DIR" && git ls-files | xargs -n 1 dirname | sed "s#^#'$HOME/##" | sed "s#\$#'##" | tr '\n' '\0' | xargs -n 1 -0 mkdir -p)

# symlink all files
while read -r line; do
  current_dir="$HOME/$(dirname "$line")"
  (cd "$current_dir" >/dev/null && \
     ln -fs "$(realpath --relative-to="$current_dir" "$DOT_FILES_DIR")/$line"   "$(basename "$line")")
done < <(cd "$DOT_FILES_DIR" && git ls-files)

