#!/usr/bin/env bash

# ensure directories
DOT_FILES_DIR="$(realpath "$(git rev-parse --show-toplevel)")"

(cd "$DOT_FILES_DIR" && git ls-files |\
                          grep -vE '^bin/|Makefile' |\
                          xargs -n 1 dirname |\
                          sed "s#^#'$HOME/##" |\
                          sed "s#\$#'##" |\
                          xargs -n 1 mkdir -p)

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


# link tool folders if in container or in lima vm/lima-vm
if [ -n "$NOT_HOST_ENV" ]; then
  # Hint all tool folders sit right next to $DOT_FILES_DIR

  test -e ~/Documents || ln -f -s "$DOT_FILES_DIR"/../../Documents  ~/Documents

  folder_name=.not_host_env
  test -e ~/"$folder_name" || ln -f -s "$DOT_FILES_DIR"/../../"$folder_name"  ~/"$folder_name"
  unset folder_name

  folder_name=.cache/rizin
  test -e ~/"$folder_name" || ln -f -s "$DOT_FILES_DIR"/../../"$folder_name"  ~/"$folder_name"
  unset folder_name

  unlink ~/.vim >/dev/null 2>&1 || rm -rf ~/.vim
  ln -f -s "$DOT_FILES_DIR"/../../.vim  ~/.vim

  path="$DOT_FILES_DIR"/../../.ssh
  for file in "$path"/*; do
    bname="$(basename "$file")"
    if [ "$bname" = known_hosts ] || \
       [ "$bname" = authorized_keys ]; then
      continue
    fi

    ln -f -s "$path"/"$bname"  ~/.ssh/"$bname"
  done
  unset path

fi

