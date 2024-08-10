{ clang, stdenvNoCC, ... }:
stdenvNoCC.mkDerivation {
  pname = "emacs-clang-tools";
  version = clang.cc.version;
  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/share/emacs/site-lisp
    cp ${clang.cc}/share/clang/clang-{format,rename,include-fixer}.el $out/share/emacs/site-lisp/
  '';
}
