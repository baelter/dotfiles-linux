#!/bin/bash
# Git info that respects bare repos (hides in bare repo root)

git_dir=$(git rev-parse --git-dir 2>/dev/null)

# Hide git info if we're in the bare repo root itself (not a worktree)
if [[ -n "$git_dir" && "$git_dir" == "." && $(git config --get core.bare 2>/dev/null) == "true" ]]; then
  exit 0  # Return empty - in bare repo
fi

# Not in bare repo, show git info
if [[ -z "$git_dir" ]]; then
  exit 0  # Not in a git repo
fi

# Get branch name
branch=$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)

# Get git status indicators
status_output=$(git status --porcelain 2>/dev/null)
ahead_behind=$(git rev-list --left-right --count @{upstream}...HEAD 2>/dev/null)

output=""
if [[ -n "$branch" ]]; then
  output="${branch}"
fi

# Add status indicators
if [[ -n "$status_output" ]]; then
  untracked=$(echo "$status_output" | grep -c "^??")
  modified=$(echo "$status_output" | grep -c "^ M")

  [[ $untracked -gt 0 ]] && output+=" ?"
  [[ $modified -gt 0 ]] && output+=" "
fi

# Add ahead/behind indicators
if [[ -n "$ahead_behind" ]]; then
  behind=$(echo "$ahead_behind" | cut -f1)
  ahead=$(echo "$ahead_behind" | cut -f2)

  [[ $ahead -gt 0 ]] && output+=" ⇡${ahead}"
  [[ $behind -gt 0 ]] && output+=" ⇣${behind}"
fi

echo "$output"
