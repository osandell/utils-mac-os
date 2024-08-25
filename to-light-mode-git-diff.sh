#!/usr/bin/env bash

new_delta_config="[delta]
    light = true
    file-decoration-style = \"#657b83 ul\"
    file-style = \"#657b83\"
    hunk-header-decoration-style = \"#657b83 box\"
    hunk-header-line-number-style = \"#657b83\"
    line-numbers = true
    line-numbers-left-format = \"{nm:>3}│\"
    line-numbers-left-style = \"#657b83\"
    line-numbers-minus-style = \"#657b83\"
    line-numbers-plus-style = \"#657b83\"
    line-numbers-right-format = \"{np:>3}│\"
    line-numbers-right-style = \"#657b83\"
    line-numbers-zero-style = \"#657b83\"
    minus-emph-style = \"syntax #ffac9b\"
    minus-empty-line-marker-style = \"#ffcdbb\"
    minus-style = \"syntax #ffcdbb\"
    navigate = false
    plus-emph-style = \"syntax bold #d7e2a5\"
    plus-empty-line-marker-style = \"#d7e2a5\"
    plus-style = \"syntax #eaeac8\"
    side-by-side = false
    syntax-theme = \"Solarized (light)\"
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
