emulate -L zsh -o function_argzero
autoload -Uz n
fpath=("${0:a:h}" $fpath)
