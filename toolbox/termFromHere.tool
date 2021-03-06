#!/bin/bash
# terminal in the current directory
# depends: xorg-xdpyinfo xorg-xprop

CWD=''

# Get window ID
ID=$(xdpyinfo | grep focus | cut -f4 -d " ")

# Get PID of process whose window this is
PID=$(xprop -id "$ID" | grep -m 1 PID | cut -d " " -f 3)

{
    # Get last child process (shell, vim, etc)
    if [[ "$PID" ]]; then
        CPID=$(pstree -lpA "$PID" |
            grep -oP '(bash|zsh|vim|nvim)\([0-9]+\)' |
            tail -1 |
            grep -oP '[0-9]+')

  # If we find the working directory, run the command in that directory
  if [ -e "/proc/$CPID/cwd" ]; then
      CWD=$(readlink /proc/"$CPID"/cwd)
  fi
    fi
    if [[ "$CWD" ]]; then
        cd "$CWD" || exit 1
        "$TERMINAL" "$@" &
    else
        notify-send -u low -a termFromHere "Couldn't find cwd"
        "$TERMINAL" "$@" &
    fi
    disown
    exit
} &>> "$XDG_CACHE_HOME/termFromHereLog" &
