#!/usr/bin/env nu

def compact [text: string, limit: int = 40] {
  let cleaned = ($text | str replace --all "\n" " " | str trim)
  let chars = ($cleaned | split chars)
  if (($chars | length) > $limit) {
    $chars | first ($limit - 1) | str join | $"($in)…"
  } else {
    $cleaned
  }
}

let players = (try { ^playerctl -l | lines } catch { [] })
let candidates = ($players | where {|p| $p | str starts-with "musicfox" })

if ($candidates | is-empty) {
  print "No music"
  exit 0
}

let player = ($candidates | first)
let status = (try { ^playerctl -p $player status | str trim } catch { "Stopped" })
let title = (try { ^playerctl -p $player metadata xesam:title | str trim } catch { "" })
let lyrics = (try { ^playerctl -p $player metadata xesam:asText } catch { "" })
let pos = (try { ^playerctl -p $player position | into float } catch { -1.0 })

if ($status == "Paused") {
  if ($title | is-empty) {
    print "Paused"
  } else {
    print (compact $"  ($title)")
  }
  exit 0
}

if ($status != "Playing") {
  print "No music"
  exit 0
}

if (($lyrics | str trim | is-empty) or ($pos < 0)) {
  if ($title | is-empty) {
    print "No music"
  } else {
    print (compact $title)
  }
  exit 0
}

let parsed = (
  $lyrics
  | lines
  | parse --regex '^\[(?<mm>\d+):(?<ss>\d+(?:\.\d+)?)\](?<text>.*)$'
  | each {|row|
      {
        time: ((($row.mm | into int) * 60) + ($row.ss | into float))
        text: ($row.text | str trim)
      }
    }
  | where {|row| ($row.text | is-not-empty) and ($row.time <= $pos) }
)

if ($parsed | is-empty) {
  if ($title | is-empty) {
    print "No music"
  } else {
    print (compact $title)
  }
} else {
  print (compact ($parsed | last | get text))
}
