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
  TERMINFO_DIRS: "/var/home/cyrene/.nix-profile/share/terminfo:/etc/terminfo:/usr/share/terminfo:/lib/terminfo"
  NIX_PATH: (if "NIX_PATH" in $env { $env.NIX_PATH } else { "nixpkgs=flake:nixpkgs" })
}

$env.EXA_API_KEY = (bash -c 'source ~/.bashrc;echo $EXA_API_KEY')

let mise_path = $nu.default-config-dir | path join mise.nu
if (which mise | is-not-empty) {
  ^mise activate nu | save $mise_path --force
}
