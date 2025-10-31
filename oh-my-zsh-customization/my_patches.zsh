# Custom directory display for git worktrees
function prompt_dir() {
  local git_dir=$(git rev-parse --git-dir 2>/dev/null)

  if [[ -n "$git_dir" ]]; then
    # Check if we're in a worktree
    if [[ "$git_dir" == *"/worktrees/"* ]]; then
      # We're in a worktree
      local worktree_path=$(git rev-parse --show-toplevel 2>/dev/null)
      if [[ -n "$worktree_path" ]]; then
        # Check if we're at the worktree root or in a subdirectory
        if [[ "$PWD" == "$worktree_path" ]]; then
          # At worktree root: show repo/worktree
          local worktree_name=$(basename "$worktree_path")
          local repo_path=$(dirname "$worktree_path")
          local repo_name=$(basename "$repo_path")
          echo "%{$fg[cyan]%}${repo_name}/${worktree_name}%{$reset_color%}"
        else
          # In subdirectory: show just current directory
          echo "%{$fg[cyan]%}%c%{$reset_color%}"
        fi
        return
      fi
    elif [[ $(git config --get core.bare 2>/dev/null) == "true" ]]; then
      # We're in a bare repo
      echo "%{$fg[cyan]%}$(basename "$PWD")%{$reset_color%}"
      return
    fi
  fi

  # Default: just show current directory
  echo "%{$fg[cyan]%}%c%{$reset_color%}"
}

# Override git_prompt_info to handle bare repos
function git_prompt_info() {
  local git_dir=$(git rev-parse --git-dir 2>/dev/null)

  # Only hide git info if we're in the bare repo root itself (not a worktree)
  if [[ -n "$git_dir" && "$git_dir" == "." && $(git config --get core.bare 2>/dev/null) == "true" ]]; then
    return
  fi

  # Use the async output from oh-my-zsh for regular repos and worktrees
  if [[ -n "${_OMZ_ASYNC_OUTPUT[_omz_git_prompt_info]}" ]]; then
    echo -n "${_OMZ_ASYNC_OUTPUT[_omz_git_prompt_info]}"
  fi
}
