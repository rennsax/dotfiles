{
  lib,
  stdenvNoCC,
  fetchurl,
  unzip,
  ...
}:
stdenvNoCC.mkDerivation rec {
  pname = "macos-trash";
  version = "v1.2.0";
  src = fetchurl {
    url = "https://github.com/sindresorhus/macos-trash/releases/download/${version}/trash.zip";
    hash = "sha256-hJc2rFosV+LQfXnf4ssagfpLaShFho/ths2HJ6t1tzw=";
  };
  sourceRoot = ".";
  nativeBuildInputs = [ unzip ];
  installPhase = ''
    runHook preInstall
    install -vDt $out/bin trash
    runHook postInstall
  '';

  meta = with lib; {
    platforms = [ "aarch64-darwin" ];
  };

}
