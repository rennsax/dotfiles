{
  lib,
  clang-unwrapped,
  runCommandLocal,
}:
runCommandLocal "emacs-clang-tools-${lib.getVersion clang-unwrapped}" { } ''
  mkdir -p $out/share/emacs/site-lisp
  cp ${clang-unwrapped}/share/clang/clang-{format,rename,include-fixer}.el $out/share/emacs/site-lisp/
''
