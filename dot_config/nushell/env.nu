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
    | str join ":"
  )
  EDITOR: "nvim"
  HOME: "/var/home/cyrene"
  XDG_CACHE_HOME: "/var/home/cyrene/.cache"
}

let mise_path = $nu.default-config-dir | path join mise.nu
if (which mise | is-not-empty) {
  ^mise activate nu | save $mise_path --force
}
