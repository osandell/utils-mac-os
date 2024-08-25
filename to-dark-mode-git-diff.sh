#!/usr/bin/env bash

new_delta_config="[delta]
    syntax-theme = \"gruvbox-dark\"
    light = false
    line-numbers = true
    line-numbers-left-format = \"{nm:>3}│\"
    line-numbers-minus-style = \"#cc241d\"
    line-numbers-right-format = \"{np:>3}│\"
    navigate = false
    side-by-side = false
    true-color = auto
    zero-style = \"syntax\""

cp ~/.gitconfig ~/.gitconfig.backup

awk '
  BEGIN { in_delta=0 }
  /^\[delta\]/ { in_delta=1; next }
  /^\[/ { in_delta=0 }
  !in_delta { print }
' ~/.gitconfig >~/.gitconfig.tmp

echo "$new_delta_config" >>~/.gitconfig.tmp
mv ~/.gitconfig.tmp ~/.gitconfig
echo "[delta] section in ~/.gitconfig has been replaced with the new light mode configuration."
