#!/bin/sh

while true
do
  SELECTED=`ls -d */* | fzf --no-mouse -m | awk '{print "\"" $0 "\""}'`
  if [ -z "$SELECTED" ]
  then
      read action
      $action
      continue
  fi

  clear
  echo $SELECTED
  printf "$ "
  read action
  if [ "$action" = "vi" ]; then
      session="Code"
      tmux new-session -d -s $session
      tmux new-window -t $session:1 -n 'NVim'
      tmux send-keys -t 'NVim' "nvim $SELECTED" C-m
      tmux attach-session -t $SESSION:1
  elif [ "$action" = "mpv" ]; then
      eval $action $SELECTED > /dev/null 2>&1 &
  else
      eval $action $SELECTED
  fi
done
