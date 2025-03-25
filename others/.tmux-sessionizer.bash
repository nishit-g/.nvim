#!/usr/bin/env bash

# Configuration
MAX_DEPTH=2                    # Maximum depth for directory search
SEARCH_DIRS="$HOME/work $HOME/personal"   # Default search directories
EXCLUDES=("node_modules" ".git" "vendor") # Directories to exclude
CACHE_FILE="$HOME/.tmux-sessionizer-cache"
CACHE_TTL=3600                # Cache TTL in seconds (1 hour)

function join_by {
    local IFS="$1"
    shift
    echo "$*"
}

# Create exclude pattern for find command
EXCLUDE_PATTERN=$(printf " -not -path '*/%s/*'" "${EXCLUDES[@]}")

function refresh_cache() {
    find $SEARCH_DIRS -mindepth 1 -maxdepth $MAX_DEPTH -type d $EXCLUDE_PATTERN > "$CACHE_FILE"
}

function get_directories() {
    # Check if cache exists and is fresh
    if [[ -f "$CACHE_FILE" ]] && [[ $(( $(date +%s) - $(stat -c %Y "$CACHE_FILE") )) -lt $CACHE_TTL ]]; then
        cat "$CACHE_FILE"
    else
        refresh_cache
        cat "$CACHE_FILE"
    fi
}


function main() {
    local selected
    
    if [[ $# -eq 1 ]]; then
        selected=$1
    else
        selected=$(get_directories | fzf \
            --header="Select project directory" \
            --preview="ls -l {}" \
            --height=40% \
            --border=rounded \
            --prompt="Project > ")
    fi

    if [[ -z "$selected" ]]; then
        exit 0
    fi

    # Ensure the selected directory exists
    if [[ ! -d "$selected" ]]; then
        echo "Directory not found: $selected"
        exit 1
    fi

}

# Handle signals
trap 'exit' INT TERM
trap 'kill 0' EXIT

# Execute main function
main "$@"
