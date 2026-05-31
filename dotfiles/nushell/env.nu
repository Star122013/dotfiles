$env.config.buffer_editor = "hx"
$env.config.show_banner = false

load-env {
  PATH: (
    $env.PATH
    | append "/usr/local/bin"
    | append "/usr/bin"
    | append "/bin"
    | append "/home/linuxbrew/.linuxbrew/bin/"
    | append "/var/home/cyrene/.zvm/bin"
    | append "/var/home/cyrene/.pixi/bin"
    | str join ":"
  )
  EDITOR: "hx"
  HOME: "/var/home/cyrene"
  XDG_CACHE_HOME: "/var/home/cyrene/.cache"
}

$env.EXA_API_KEY = (bash -c 'source ~/.bashrc;echo $EXA_API_KEY')

