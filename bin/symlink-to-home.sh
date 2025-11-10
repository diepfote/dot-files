#!/usr/bin/env bash

_skip_exclusions () {
  if [ "$system" != Darwin ]; then
    # skip Mac OS only config on Linux
    if \
       [[ "$line" =~ .*xbar.* ]] || \
       [[ "$line" =~ .*karabiner.* ]] || \
       [[ "$line" =~ .*lima.* ]] || \
       [[ "$line" =~ .*yabai.* ]] || \
       [[ "$line" =~ .*Library/Application.* ]]; then
      return 0
    fi
  else
    # skip Linux only config
    if \
       [[ "$line" =~ .*\.config/autostart.* ]] || \
       [[ "$line" =~ .*\.config/i3.* ]]; then
      return 0
    fi
  fi

  return 1
}

_ensure_dir_exists () {

(
  die () { echo Failed to cd dir; exit 1; }
  cd "$DOT_FILES_DIR" || die

  _dir="$(dirname "$1" | sed "s#^#$HOME/##")"

  if [ "$_dir" = "$HOME"/. ]; then
    exit
  fi
  echo "[.] ensure exists $_dir"
  mkdir -p "$_dir"
)

}

_copy-file-to-dot-files () {
  cp ~/"$1" "$1"
}

# ensure directories
DOT_FILES_DIR="$(realpath "$(git rev-parse --show-toplevel)")"


system="$(uname)"

# ensure dirs exist
while read -r line; do

  if _skip_exclusions; then
    continue
  fi

  _ensure_dir_exists "$line"
done < <(cd "$DOT_FILES_DIR" && git ls-files | grep -vE '^bin/|Makefile')


# symlink all files
while read -r line; do

  if _skip_exclusions; then
    continue
  fi

  if [[ "$line" =~ .*\.config/karabiner/karabiner\.json ]]; then
      # do not symlink as this breaks keybindings
      # and do not link if this is linux -> so both continue

    if [ "$system" = Darwin ]; then
      if [ ! -f ~/"$line" ]; then
        echo "$line"
        cp "$line" ~/"$line"
      else
        set -x
        # in case the file exists copy it to the dot-files repo -> to commit changes
        _copy-file-to-dot-files "$line"
        set +x
      fi
    fi


    # do not override custom behavior with a symlink
    # and ignore on Linux
    continue
  fi


  echo "$line"
  current_dir="$HOME/$(dirname "$line")"
  (cd "$current_dir" >/dev/null && \
     ln -fs "$(realpath --relative-to="$current_dir" "$DOT_FILES_DIR")/$line"   "$(basename "$line")")

done < <(cd "$DOT_FILES_DIR" && git ls-files | grep -vE '^bin/|Makefile')


# LIMA specific
# link tool folders if in container or in lima vm/lima-vm
if [ -n "$NOT_HOST_ENV" ]; then
  # Hint all tool folders sit right next to $DOT_FILES_DIR

  test -e ~/Repos || ln -f -s "$DOT_FILES_DIR"/../../Repos  ~/Repos

  test -e ~/.config/personal || ln -f -s "$DOT_FILES_DIR"/../../.config/personal  ~/.config/personal

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

