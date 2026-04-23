{
  stdenv,
  cmake,
  libvterm-neovim,
  fetchFromGitHub,
}:

let
  installPrefix = "share/emacs/site-lisp/vterm-module";
in
stdenv.mkDerivation rec {
  pname = "emacs-libvterm-module";
  version = "54c29d1";
  src = fetchFromGitHub {
    owner = "akermu";
    repo = "emacs-libvterm";
    rev = version;
    hash = "sha256-ZSkGvKPhX4yZ2HNeNuHI7a01kjzBNBTdsWTj7y/xi8s=";
  };
  nativeBuildInputs = [ cmake ];
  buildInputs = [ libvterm-neovim ];
  installPhase = ''
    runHook preInstall
    mkdir -p $out/${installPrefix}
    cp ../vterm-module.so $out/${installPrefix}/
    runHook postInstall
  '';
}
