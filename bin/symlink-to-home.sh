#!/usr/bin/env bash

# ensure directories
DOT_FILES_DIR="$(realpath "$(git rev-parse --show-toplevel)")"

(cd "$DOT_FILES_DIR" && git ls-files | grep -vE '^bin/|Makefile' | xargs -n 1 dirname | sed "s#^#'$HOME/##" | sed "s#\$#'##" | xargs -n 1 mkdir -p)

# symlink all files
while read -r line; do
  if [[ "$(uname)" != Darwin && "$line" =~ .*xbar.* ]]; then
    # skip xbar.app plugins for Linux. Darwin only
    continue
  fi

  current_dir="$HOME/$(dirname "$line")"
  (cd "$current_dir" >/dev/null && \
     ln -fs "$(realpath --relative-to="$current_dir" "$DOT_FILES_DIR")/$line"   "$(basename "$line")")
done < <(cd "$DOT_FILES_DIR" && git ls-files | grep -vE '^bin/|Makefile')


if [ -n "$IN_CONTAINER" ]; then
  # link tool folders if in container or in lima vm

  # Hint all tool folders sit right next to $DOT_FILES_DIR

  ln -f -s "$DOT_FILES_DIR"/../../.container  ~/.container

  mkdir -p ~/Documents
  ln -f -s "$DOT_FILES_DIR"/../scripts ~/Documents/scripts
  ln -f -s "$DOT_FILES_DIR"/../cheatsheets ~/Documents/cheatsheets
  ln -f -s "$DOT_FILES_DIR"/../config ~/Documents/config

  mkdir -p ~/Documents/{golang,python}
  ln -f -s "$DOT_FILES_DIR"/../golang/tools ~/Documents/golang/tools
  ln -f -s "$DOT_FILES_DIR"/../python/tools ~/Documents/python/tools
fi

