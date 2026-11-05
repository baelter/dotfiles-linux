#!/bin/bash
# Returns success (0) if NOT in a bare repo, failure (1) if in bare repo
# This is used to conditionally show git info

git_dir=$(git rev-parse --git-dir 2>/dev/null)

# Only return failure if we're in the bare repo root itself (not a worktree)
if [[ -n "$git_dir" && "$git_dir" == "." && $(git config --get core.bare 2>/dev/null) == "true" ]]; then
  exit 1  # In bare repo - hide git info
fi

exit 0  # Show git info
