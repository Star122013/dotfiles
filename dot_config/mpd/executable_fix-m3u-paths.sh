#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Fix MPD playlist entry paths by checking files under music_directory.

Usage:
  fix-m3u-paths.sh [options]

Options:
  -m, --music-dir DIR      Music root (default: ~/Music)
  -p, --playlist-dir DIR   Playlist dir (default: ~/.config/mpd/playlists)
  --prefix DIR             Optional prefix to try first (e.g. "mimi")
  -n, --dry-run            Show planned changes without writing files
  --no-backup              Do not create timestamped backups
  -h, --help               Show this help

Notes:
  - Comments and blank lines are preserved.
  - If an entry path is missing, the script tries:
    1) PREFIX/entry (when --prefix is set)
    2) Unique basename match anywhere under music-dir
  - Ambiguous or missing matches are reported and left unchanged.
EOF
}

music_dir="${HOME}/Music"
playlist_dir="${HOME}/.config/mpd/playlists"
prefix=""
dry_run=0
backup=1

while [[ $# -gt 0 ]]; do
  case "$1" in
    -m|--music-dir)
      music_dir="${2:-}"
      shift 2
      ;;
    -p|--playlist-dir)
      playlist_dir="${2:-}"
      shift 2
      ;;
    --prefix)
      prefix="${2:-}"
      shift 2
      ;;
    -n|--dry-run)
      dry_run=1
      shift
      ;;
    --no-backup)
      backup=0
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

if [[ ! -d "$music_dir" ]]; then
  echo "music-dir not found: $music_dir" >&2
  exit 1
fi

if [[ ! -d "$playlist_dir" ]]; then
  echo "playlist-dir not found: $playlist_dir" >&2
  exit 1
fi

music_dir="$(cd "$music_dir" && pwd -P)"
playlist_dir="$(cd "$playlist_dir" && pwd -P)"

timestamp="$(date +%Y%m%d-%H%M%S)"
playlist_count=0
changed_playlists=0
changed_entries_total=0
missing_total=0
ambiguous_total=0

shopt -s nullglob
playlists=("$playlist_dir"/*.m3u "$playlist_dir"/*.m3u8)

if [[ ${#playlists[@]} -eq 0 ]]; then
  echo "No .m3u/.m3u8 files found in $playlist_dir"
  exit 0
fi

for pl in "${playlists[@]}"; do
  [[ -f "$pl" ]] || continue
  playlist_count=$((playlist_count + 1))

  tmp="$(mktemp "${pl}.tmp.XXXXXX")"
  line_no=0
  changed_entries=0
  missing=0
  ambiguous=0

  while IFS= read -r line || [[ -n "$line" ]]; do
    line_no=$((line_no + 1))

    if [[ -z "$line" || "$line" == \#* ]]; then
      printf '%s\n' "$line" >> "$tmp"
      continue
    fi

    entry="$line"
    resolved="$entry"

    if [[ -f "$music_dir/$entry" ]]; then
      :
    else
      resolved=""

      if [[ -n "$prefix" && -f "$music_dir/$prefix/$entry" ]]; then
        resolved="$prefix/$entry"
      else
        base="$(basename "$entry")"
        matches=()

        while IFS= read -r -d '' abs; do
          rel="${abs#"$music_dir"/}"
          matches+=("$rel")
        done < <(find "$music_dir" -type f -name "$base" -print0)

        if [[ ${#matches[@]} -eq 1 ]]; then
          resolved="${matches[0]}"
        elif [[ ${#matches[@]} -gt 1 ]]; then
          ambiguous=$((ambiguous + 1))
          echo "[ambiguous] $(basename "$pl"):$line_no  $entry" >&2
          echo "            candidates: ${matches[*]}" >&2
          resolved="$entry"
        else
          missing=$((missing + 1))
          echo "[missing]   $(basename "$pl"):$line_no  $entry" >&2
          resolved="$entry"
        fi
      fi
    fi

    if [[ "$resolved" != "$entry" ]]; then
      changed_entries=$((changed_entries + 1))
      printf '%s\n' "$resolved" >> "$tmp"
    else
      printf '%s\n' "$entry" >> "$tmp"
    fi
  done < "$pl"

  if [[ $changed_entries -gt 0 ]]; then
    changed_playlists=$((changed_playlists + 1))
    changed_entries_total=$((changed_entries_total + changed_entries))

    if [[ $dry_run -eq 1 ]]; then
      echo "[dry-run] $(basename "$pl"): would update $changed_entries entries"
      rm -f "$tmp"
    else
      if [[ $backup -eq 1 ]]; then
        cp -- "$pl" "${pl}.bak.${timestamp}"
      fi
      mv -- "$tmp" "$pl"
      echo "[updated] $(basename "$pl"): $changed_entries entries"
    fi
  else
    rm -f "$tmp"
    echo "[ok]      $(basename "$pl"): no changes"
  fi

  missing_total=$((missing_total + missing))
  ambiguous_total=$((ambiguous_total + ambiguous))
done

echo
echo "Playlists scanned : $playlist_count"
echo "Playlists changed : $changed_playlists"
echo "Entries changed   : $changed_entries_total"
echo "Missing entries   : $missing_total"
echo "Ambiguous entries : $ambiguous_total"

