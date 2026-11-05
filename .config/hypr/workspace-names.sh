#!/bin/bash
set -euo pipefail

update_names() {
    hyprctl -j clients 2>/dev/null | jq -r '
        group_by(.workspace.id)[] |
        sort_by(.focusHistoryID)[0] |
        [(.workspace.id | tostring), .class, .title] |
        @tsv
    ' | while IFS=$'\t' read -r ws_id class title; do
        case "$class" in
            Alacritty|foot|kitty|ghostty)
                # Extract directory from title (bash sets user@host:path)
                name="${title##*/}"    # last path component
                name="${name##*:}"     # strip user@host: prefix
                # For branch names, prepend project dir
                case "$name" in
                    main|master|dev|develop|staging|production)
                        parent="${title%/*}"
                        parent="${parent##*/}"
                        parent="${parent##*:}"
                        [[ -n "$parent" && "$parent" != "~" ]] && name="${parent}/${name}"
                        ;;
                esac
                name="${name:0:20}"
                ;;
            *)
                # For other apps just use the class name - icon already shows the app
                name="${class,,}"
                name="${name:0:12}"
                ;;
        esac
        [[ -n "$name" ]] && hyprctl dispatch renameworkspace "$ws_id" "$name" >/dev/null 2>&1
    done
}

update_names

socket="${XDG_RUNTIME_DIR}/hypr/${HYPRLAND_INSTANCE_SIGNATURE}/.socket2.sock"
socat - "UNIX-CONNECT:${socket}" | while IFS= read -r event; do
    case "${event%%>>*}" in
        activewindow|openwindow|closewindow|movewindow)
            update_names
            ;;
    esac
done
