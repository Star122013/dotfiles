set -g fish_greeting

function fish_user_key_bindings
    # 设置 Ctrl+f 启动 tv 选择文件
    bind \cf 'set -l result (tv); and commandline -i -- $result; commandline -f repaint'
    
    # 如果你想用 Ctrl+g 打开 tv 的 git 模式 (如果有的话)
    bind \cg 'set -l result (tv git-repos); and commandline -i -- $result; commandline -f repaint'
end

fish_config theme choose "tokyo-night-moon"

set -gx FZF_DEFAULT_OPTS "
  $FZF_DEFAULT_OPTS \
  --style full \
  --highlight-line \
  --info=inline-right \
  --ansi \
  --layout=reverse \
  --border=none \
  --color=bg+:#2d3f76 \
  --color=bg:#1e2030 \
  --color=border:#589ed7 \
  --color=fg:#c8d3f5 \
  --color=gutter:#1e2030 \
  --color=header:#ff966c \
  --color=hl+:#65bcff \
  --color=hl:#65bcff \
  --color=info:#545c7e \
  --color=marker:#ff007c \
  --color=pointer:#ff007c \
  --color=prompt:#65bcff \
  --color=query:#c8d3f5:regular \
  --color=scrollbar:#589ed7 \
  --color=separator:#ff966c \
  --color=spinner:#ff007c \
"

abbr -a l eza --icons -a --group-directories-first -1
abbr -a ll eza --icons  -a --group-directories-first -1 --no-user --long
abbr -a tree eza --icons --tree --group-directories-first

tv init fish | source
starship init fish | source
mise activate fish | source
