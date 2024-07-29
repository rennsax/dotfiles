{
  stdenv,
  cmake,
  libvterm-neovim,
  fetchFromGitHub,
  ...
}:

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
    mkdir -p $out/lib
    cp ../vterm-module.so $out/lib/
  '';
}
