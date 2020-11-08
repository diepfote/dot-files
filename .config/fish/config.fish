set fish_greeting ''

if [ (tty) = /dev/tty1 ]
  startxfce4
else

  set -x PATH "$HOME/go/bin" $PATH  # add go/bin to PATH

  set -x EDITOR nvim
  set -x VISUAL nvim


  set -x LESSSECURE 1
  # due to https://phoenhex.re/2018-03-25/not-a-vagrant-bug
  set -x VAGRANT_DISABLE_VBOXSYMLINKCREATE 1

  set -x PYTHONSTARTUP ~/.python_startup



  if [ (uname) = Darwin ]
    alias grep='ggrep --exclude-dir=.git --color'
    alias find=gfind
  else
      alias grep='grep --exclude-dir=.git --color'
      set -x PASSWORD_STORE_DIR ~/.password-store-private
  end


  # IS INTERACTIVE!
  #
  #
  if status is-interactive

    # Fix CTRL+W behavior (kill words not whole paths/path components
    bind \cw backward-kill-word


    set -x NNN_COLORS 2136  # use a different color for each context -> version >= 3.2
    set -x NNN_TRASH 1
    set -x NNN_BMS "d:~/Documents;h:~;D:~/Downloads;f:~/.config/fish/functions;s:~/Documents/scripts;L:~/Library/LaunchAgents;l:~/Documents/systemd-user;S:~/.config/systemd/user;E:/etc/;v:~/Videos;V:/run/media/$USER/large_drive/Media/Video-Files/Videos;m:~/Movies;b:~/Documents/wir/bauen_haus;p:~/Documents/wir/bauen_haus/pläne"  # jump locations for nnn
    set -x NNN_FIFO /tmp/nnn.fifo
    set -x NNN_PLUG 'p:preview-tui;v:imgview;t:imgthumb'   # curl -Ls https://raw.githubusercontent.com/jarun/nnn/master/plugins/getplugs | sh


    set -x FZF_DEFAULT_OPTS '--height 40% --layout=reverse --border'

    # colorize man pages using 'bat'
    set -x MANPAGER "sh -c 'col -bx | bat -l man -p'"


    set direnv_location (which direnv 2>/dev/null)
    if [ -n "$direnv_location" ]
      eval (direnv hook fish)
    end

    set gh_location (which gh 2>/dev/null)
    if [ -n "$gh_location" ]
      eval (gh completion -s fish)
    end

    # source self-written completions
    source ~/.config/fish/completions



    #
    # set colors
    # refer to https://fishshell.com/docs/current/index.html#variables-color
    #
    #The following variables are available to change the highlighting colors in fish:
        #fish_color_normal, the default color
        #fish_color_command, the color for commands
        #fish_color_quote, the color for quoted blocks of text
        #fish_color_redirection, the color for IO redirections
        #fish_color_end, the color for process separators like ';' and '&'
        #fish_color_error, the color used to highlight potential errors
        #fish_color_param, the color for regular command parameters
        #fish_color_comment, the color used for code comments
        #fish_color_match, the color used to highlight matching parenthesis
        #fish_color_selection, the color used when selecting text (in vi visual mode)
        #fish_color_search_match, used to highlight history search matches and the selected pager item (must be a background)
        #fish_color_operator, the color for parameter expansion operators like '*' and '~'
        #fish_color_escape, the color used to highlight character escapes like '\n' and '\x70'
        #fish_color_cwd, the color used for the current working directory in the default prompt
        #fish_color_autosuggestion, the color used for autosuggestions
        #fish_color_user, the color used to print the current username in some of fish default prompts
        #fish_color_host, the color used to print the current host system in some of fish default prompts
        #fish_color_cancel, the color for the '^C' indicator on a canceled command

    #Additionally, the following variables are available to change the highlighting in the completion pager:

        #fish_pager_color_prefix, the color of the prefix string, i.e. the string that is to be completed
        #fish_pager_color_completion, the color of the completion itself
        #fish_pager_color_description, the color of the completion description
        #fish_pager_color_progress, the color of the progress bar at the bottom left corner
        #fish_pager_color_secondary, the background color of the every second completion
    #
    set -x fish_color_command purple
    set -x fish_color_param green
    set -x fish_color_end normal
    set -x fish_color_escape green
    set -x fish_pager_color_description yellow
    set -x fish_color_quote yellow
    set -x fish_color_autosuggestion 848484
    set -x fish_color_operator fa5bd0





    if not set -q TMUX
      set default_tmux_cmd "tmux -2 -u new"  # -u -> utf-8; -2 -> force 256 colors

      if ! tmux list-sessions 2>/dev/null
        eval $default_tmux_cmd 'sleep 2; tmux source ~/.tmux.conf; tmux detach'
      else
        eval $default_tmux_cmd
      end
    end
    #
    #
    # on ubuntu - old fish versions
    #test $TERM != "screen"; and tmux

  end
end

