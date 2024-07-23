{
  fetchzip,
  lib,
  stdenvNoCC,
  ...
}:

let
  appName = "Hammerspoon.app";
in

stdenvNoCC.mkDerivation rec {
  pname = "hammerspoon";
  version = "0.9.100";

  src = fetchzip {
    url = "https://github.com/Hammerspoon/hammerspoon/releases/download/${version}/Hammerspoon-${version}.zip";
    hash = "sha256-Q14NBizKz7LysEFUTjUHCUnVd6+qEYPSgWwrOGeT9Q0=";
  };

  dontFixup = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/Applications/${appName}
    cp -R . $out/Applications/${appName}
    runHook postInstall
  '';
}
