{
  fetchzip,
  stdenvNoCC,
}:
let
  appName = "Hammerspoon.app";
in

stdenvNoCC.mkDerivation rec {
  pname = "hammerspoon";
  version = "1.0.0";

  src = fetchzip {
    url = "https://github.com/Hammerspoon/hammerspoon/releases/download/${version}/Hammerspoon-${version}.zip";
    hash = "sha256-vqjYCzEXCYBx/gJ32ZNAioruVDy9ghftPAOFMDtYcc0=";
  };

  preferLocalBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications/${appName}
    cp -R . $out/Applications/${appName}

    runHook postInstall
  '';
}
