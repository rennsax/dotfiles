{
  lib,
  stdenv,
  pkg-config,
  enchant,
  fetchFromGitHub,
}:
let
  moduleName = "jinx-mod";
  moduleFileName = moduleName + ".so";
  installPrefix = "share/emacs/site-lisp/${moduleName}";
in
stdenv.mkDerivation rec {
  pname = moduleName;
  version = "1.11";
  src = fetchFromGitHub {
    owner = "minad";
    repo = "jinx";
    rev = version;
    hash = "sha256-Y3h07oawqtg1PPwSyq2UqBrkHSVb1DPmFu6hu3vD1ok=";
  };
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ enchant ];
  buildPhase = ''
    runHook preBuild
    $CC -I. -O2 -Wall -Wextra -fPIC -shared -o ${moduleFileName} jinx-mod.c $($PKG_CONFIG --cflags --libs enchant-2)
    runHook postBuild
  '';
  installPhase = ''
    runHook preInstall
    mkdir -p $out/${installPrefix}
    cp ${moduleFileName} $out/${installPrefix}/
    runHook postInstall
  '';

  postFixup = lib.optionalString stdenv.isDarwin ''
    ln -s ${moduleFileName} $out/${installPrefix}/${moduleName}.dylib
  '';
}
