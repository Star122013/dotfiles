set -g fish_greeting

function fish_user_key_bindings
    # 设置 Ctrl+f 启动 tv 选择文件
    bind \cf 'set -l result (tv); and commandline -i -- $result; commandline -f repaint'
    
    # 如果你想用 Ctrl+g 打开 tv 的 git 模式 (如果有的话)
    bind \cg 'set -l result (tv git-repos); and commandline -i -- $result; commandline -f repaint'
end

function localrust
    echo "🦀 进入 Rust 隔离环境 (输入 exit 退出)..."
    # 启动一个新的 fish shell，带有修改后的 PATH
    env PATH="$HOME/.cargo/bin:$PATH" fish
    echo "👋 已退出 Rust 环境"
end

fish_config theme choose "eldritch"

set -gx FZF_DEFAULT_OPTS " \
  $FZF_DEFAULT_OPTS \
  --height 40% --tmux bottom,40% --layout reverse \
  --preview '~/.config/fzf/preview.sh {}' \
  --style=full \
  --highlight-line \
  --info=inline-right \
  --ansi \
  --layout=reverse \
  --color=bg+:#283457 \
  --color=bg:#16161e \
  --color=border:#27a1b9 \
  --color=fg:#c0caf5 \
  --color=gutter:#16161e \
  --color=header:#ff9e64 \
  --color=hl+:#2ac3de \
  --color=hl:#2ac3de \
  --color=info:#545c7e \
  --color=marker:#ff007c \
  --color=pointer:#ff007c \
  --color=prompt:#2ac3de \
  --color=query:#c0caf5:regular \
  --color=scrollbar:#27a1b9 \
  --color=separator:#ff9e64 \
  --color=spinner:#ff007c
"

abbr -a sysyadm sudo yadm --yadm-dir /etc/yadm --yadm-data /etc/yadm/data
abbr -a l eza --icons -a --group-directories-first -1
abbr -a ll eza --icons  -a --group-directories-first -1 --no-user --long
abbr -a tree eza --icons --tree --group-directories-first

starship init fish | source
