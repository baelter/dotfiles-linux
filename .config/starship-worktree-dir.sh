#!/bin/bash
# Custom directory display for git worktrees

git_dir=$(git rev-parse --git-dir 2>/dev/null)

if [[ -n "$git_dir" ]]; then
  # Check if we're in a worktree
  if [[ "$git_dir" == *"/worktrees/"* ]]; then
    # We're in a worktree
    worktree_path=$(git rev-parse --show-toplevel 2>/dev/null)
    if [[ -n "$worktree_path" ]]; then
      # Check if we're at the worktree root or in a subdirectory
      if [[ "$PWD" == "$worktree_path" ]]; then
        # At worktree root: show repo/worktree
        worktree_name=$(basename "$worktree_path")
        repo_path=$(dirname "$worktree_path")
        repo_name=$(basename "$repo_path")
        echo "${repo_name}/${worktree_name}"
      else
        # In subdirectory: show repo/worktree/subdir
        worktree_name=$(basename "$worktree_path")
        repo_path=$(dirname "$worktree_path")
        repo_name=$(basename "$repo_path")
        rel_path=${PWD#$worktree_path/}
        echo "${repo_name}/${worktree_name}/${rel_path}"
      fi
      exit 0
    fi
  elif [[ $(git config --get core.bare 2>/dev/null) == "true" ]]; then
    # We're in a bare repo
    echo "$(basename "$PWD")"
    exit 0
  fi
fi

# Default: just show current directory
echo "$(basename "$PWD")"
