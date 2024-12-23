#!/bin/bash
sleep 1
[ -x "$(command -v 1password)" ] && swaymsg "workspace 8; exec $(command -v 1password)"
sleep 2
[ -x "$(command -v alacritty)" ] && swaymsg "workspace 1; exec alacritty -e tmux new -A -s dev"
sleep 2
[ -x "$(command -v brave-browser)" ] && swaymsg "workspace 9; exec brave-browser"
