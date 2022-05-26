#!/bin/sh

# Environment variables
EDITOR=nvim
FZF_HISTORY=~/.fzf_history




while true
do
  last_search=`tail -n 1 $FZF_HISTORY`
  SELECTED=`ls -d * */* | fzf -q "$last_search" --history=$FZF_HISTORY --bind ctrl-a:select-all,ctrl-d:deselect-all,ctrl-t:toggle-all --no-mouse -m | awk '{print "\"" $0 "\""}'`
  if [ -z "$SELECTED" ]
  then
      printf '\n' >> $FZF_HISTORY # Empty search
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
      if [ -z "${TMUX}" ]; then
          tmux new-session -d -s $session
          tmux rename-window -t 0 $EDITOR
          tmux send-keys -t $EDITOR "$EDITOR $SELECTED" C-m
          tmux attach-session -t $SESSION:0
      else
          eval $EDITOR $SELECTED
      fi
  elif [ "$action" = "mpv" ]; then
      eval $action $SELECTED > /dev/null 2>&1 &
  elif [ "$action" = "feh" ]; then
      eval $action $SELECTED > /dev/null 2>&1 &
  elif [ "$action" = "cd" ]; then
      printf '\n' >> $FZF_HISTORY # Clear search after cd TODO: Do better
      eval cd $SELECTED
  else
      eval $action $SELECTED
  fi
done
