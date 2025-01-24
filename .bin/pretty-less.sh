#!/bin/bash

# Define common bat arguments with the style
BAT_ARGS="--theme=OneHalfDark --style=plain --paging=always"

# Check if input is a file
if [ -t 0 ]; then
    # File mode
    if [ -f "$1" ]; then
        batcat $BAT_ARGS "$1"
    else
        less "$@"
    fi
else
    # Piped mode
    batcat $BAT_ARGS --file-name=/dev/stdin
fi
