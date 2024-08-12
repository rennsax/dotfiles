{ stdenvNoCC, fetchurl, ... }:
stdenvNoCC.mkDerivation rec {
  name = "gnu-coding-standards";
  src = fetchurl {
    url = "https://www.gnu.org/prep/standards/standards.info.tar.gz";
    hash = "sha256-V1JBhsayLdOARQFXph0sEkQwXuHbt1xM7pV+ZzT4MwA=";
  };
  sourceRoot = ".";
  installPhase = ''
    runHook preInstall
    install -vDt $out/share/info standards.info
    runHook postInstall
  '';
}
