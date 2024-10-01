{ stdenvNoCC, fetchFromGitHub }:

stdenvNoCC.mkDerivation rec {
  pname = "iterm2-utilities";
  version = "3.5";

  src = fetchFromGitHub {
    owner = "gnachman";
    repo = "iterm2-shell-integration";
    # 3.5 is the branch name, not the tag name.
    rev = "e50c42051f8c9408c923a18d1406a5bc05414870";
    hash = "sha256-9crDf4GC708cms/4z2EL7RFLCIdFaIODInKB7huTALU=";
  };

  # gnachman/iTerm2-shell-integration includes a Makefile with unknown usage.
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp -r utilities/. $out/bin/
    runHook postInstall
  '';
}
