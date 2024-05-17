#!/usr/bin/env sh

# Try Emacs, if not found, use nvim.
emacsclient -c -q -a nvim "$@"
