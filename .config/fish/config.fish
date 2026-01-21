set -g fish_greeting

function fish_user_key_bindings
    # 设置 Ctrl+f 启动 tv 选择文件
    bind \cf 'set -l result (tv); and commandline -i -- $result; commandline -f repaint'
    
    # 如果你想用 Ctrl+g 打开 tv 的 git 模式 (如果有的话)
    bind \cg 'set -l result (tv git-repos); and commandline -i -- $result; commandline -f repaint'
end

fish_config theme choose "catppuccin-mocha"

set -gx FZF_DEFAULT_OPTS "
  $FZF_DEFAULT_OPTS \
  --style full \
  --color=bg+:#313244,bg:#1E1E2E,spinner:#F5E0DC,hl:#F38BA8 \
  --color=fg:#CDD6F4,header:#F38BA8,info:#CBA6F7,pointer:#F5E0DC \
  --color=marker:#B4BEFE,fg+:#CDD6F4,prompt:#CBA6F7,hl+:#F38BA8 \
  --color=selected-bg:#45475A \
  --color=border:#6C7086,label:#CDD6F4"

abbr -a l eza --icons -a --group-directories-first -1
abbr -a ll eza --icons  -a --group-directories-first -1 --no-user --long
abbr -a tree eza --icons --tree --group-directories-first

starship init fish | source
