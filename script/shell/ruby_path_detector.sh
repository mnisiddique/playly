#!/bin/bash

# Detect OS
OS="$(uname -s)"

if [ "$OS" = "Darwin" ]; then
  # macOS → prefer Homebrew Ruby if installed
  if [ -d "/opt/homebrew/opt/ruby/bin" ]; then
    export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
  elif [ -d "/usr/local/opt/ruby/bin" ]; then
    # Intel Macs sometimes use /usr/local instead of /opt/homebrew
    export PATH="/usr/local/opt/ruby/bin:$PATH"
  fi
else
  # Linux → prefer rbenv or rvm if installed
  if command -v rbenv >/dev/null 2>&1; then
    export PATH="$(rbenv root)/shims:$PATH"
  elif [ -s "$HOME/.rvm/scripts/rvm" ]; then
    # Load RVM if available
    source "$HOME/.rvm/scripts/rvm"
  fi
fi

# Debug: show which ruby is being used
echo "Using Ruby: $(which ruby)"
ruby --version
