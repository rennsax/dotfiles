#!/usr/bin/env sh

if ! command -v emacsclient >/dev/null 2>&1; then
    # cannot find Emacs
    nvim "$@"
else
    # Try Emacs, if not found, use nvim.
    emacsclient -c -q -a nvim "$@"
fi
