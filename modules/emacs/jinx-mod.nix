{
  stdenv,
  pkg-config,
  enchant,
  fetchFromGitHub,
  ...
}:
let
  moduleName = "jinx-mod";
  moduleFileName = moduleName + ".so";
in
stdenv.mkDerivation rec {
  pname = moduleName;
  version = "1.10";
  src = fetchFromGitHub {
    owner = "minad";
    repo = "jinx";
    rev = version;
    hash = "sha256-ddOp5BRk5GtMZ5LPU7SGUa6Z8NCmT3UnUDXTHVhJqNQ=";
  };
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ enchant ];
  buildPhase = ''
    $CC -I. -O2 -Wall -Wextra -fPIC -shared -o ${moduleFileName} jinx-mod.c $($PKG_CONFIG --cflags --libs enchant-2)
  '';
  installPhase = ''
    mkdir -p $out/lib
    cp ${moduleFileName} $out/lib/
  '';

  postFixup = ''
    ln -s ${moduleFileName} $out/lib/${moduleName}.dylib
  '';
}
