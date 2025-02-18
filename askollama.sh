#!/bin/bash

WORKING_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

copyClipboard() {
    input=$(cat)
    if command -v wl-copy >/dev/null 2>&1; then
        echo "wlcopy $input"
        echo "$input" | wl-copy
    elif command -v xclip >/dev/null 2>&1; then
        echo "$input" | xclip -selection c
    else
        echo "Neither wl-copy nor xclip is installed."
        return 1
    fi

}

# Determine available input method
if command -v wofi &> /dev/null; then
    query=$(wofi --dmenu --prompt "Enter query" | tr -d '\n')
elif command -v dmenu &> /dev/null; then
    query=$(echo "" | dmenu -p "Enter query" | tr -d '\n')
elif command -v fzf &> /dev/null; then
    query=$(echo "" | fzf --prompt="Enter query: " | tr -d '\n')
else
    notify-send "Error" "No suitable input method found. Install wofi, dmenu, or fzf."
    exit 1
fi

# Check if query is empty
if [[ -z "$query" ]]; then
    notify-send "Error" "Query input is required. Exiting."
    exit 1
fi

# Execute Lua script with arguments and capture output
output=$(lua "$WORKING_DIR/ollama-req.lua" -m "smollm2:135m" -q "$query" -s "192.168.1.77")
# songsResult=$(lua "$WORKING_DIR/songs.lua" $serverurl $username $password -f "$song")
# lua ollama-req.lua -m "smollm2:135m" -q "tell me about calico cats" -s 192.168.1.77

echo "$output" | copyClipboard

# Determine available notification method
#if command -v hyprctl &> /dev/null; then
#    hyprctl notify 0 "$output"
if command -v notify-send &> /dev/null; then
    notify-send "Ollama Answer" "$output"
else
    echo "$output"
fi

