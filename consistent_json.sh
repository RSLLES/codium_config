#!/bin/bash
cd $(dirname $0)

to_consistent() {
    tmp="$1.tmp"
    jq --sort-keys . "$1" > "$tmp" && mv "$tmp" "$1"
}

to_consistent ./extension.json 
to_consistent ./keybindings.json 
to_consistent ./settings.json 