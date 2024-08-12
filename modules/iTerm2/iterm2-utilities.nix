{ stdenvNoCC, fetchFromGitHub, ... }:

stdenvNoCC.mkDerivation rec {
  pname = "iterm2-utilities";
  version = "46f6841";

  src = fetchFromGitHub {
    owner = "gnachman";
    repo = "iterm2-shell-integration";
    # 3.5 is the branch name, not the tag name.
    rev = version;
    hash = "sha256-RKUiUcdvkhaiQIosjWvVeYrF0g6Wk58QP7ROf2o5muo=";
  };

  # gnachman/iTerm2-shell-integration includes a Makefile with unknown usage.
  dontBuild = true;
  dontFixup = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp -r utilities/. $out/bin/
    runHook postInstall
  '';
}
