set -g fish_greeting

function fish_user_key_bindings
    # 设置 Ctrl+f 启动 tv 选择文件
    bind \cf 'set -l result (tv); and commandline -i -- $result; commandline -f repaint'
    
    # 如果你想用 Ctrl+g 打开 tv 的 git 模式 (如果有的话)
    bind \cg 'set -l result (tv git-repos); and commandline -i -- $result; commandline -f repaint'
end

abbr -a l eza --icons -a --group-directories-first -1
abbr -a ll eza --icons  -a --group-directories-first -1 --no-user --long
abbr -a tree eza --icons --tree --group-directories-first

tv init fish | source
starship init fish | source
