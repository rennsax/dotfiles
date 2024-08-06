{
  stdenv,
  cmake,
  libvterm-neovim,
  fetchFromGitHub,
  ...
}:

let
  installPrefix = "share/emacs/site-lisp/vterm-module";
in
stdenv.mkDerivation rec {
  pname = "emacs-libvterm-module";
  version = "d9ea29f";
  src = fetchFromGitHub {
    owner = "akermu";
    repo = "emacs-libvterm";
    rev = version;
    hash = "sha256-rm7SjQSH50RyWt2AnTJg/gMNgA+btONjQWTEkbbywuA=";
  };
  nativeBuildInputs = [ cmake ];
  buildInputs = [ libvterm-neovim ];
  installPhase = ''
    mkdir -p $out/${installPrefix}
    cp ../vterm-module.so $out/${installPrefix}/
  '';
}
