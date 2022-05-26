open-editor() {
    S=`ls -d ~/Documents/* | fzf`
    if [ -z "$S" ]
    then
        return 0
    fi
    nvim $S
    return 0
}

open-video() {
    S=`ls ~/Downloads/*.mp4* | fzf`
    if [ -z "$S" ]
    then
        return 0
    fi
    mpv $S
    return 0
}

zle     -N            open-editor
bindkey -M vicmd '^E' open-editor
bindkey -M viins '^E' open-editor


zle     -N            open-video
bindkey -M vicmd '^V' open-video
bindkey -M viins '^V' open-video
