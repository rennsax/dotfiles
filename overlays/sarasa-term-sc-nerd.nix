{ stdenvNoCC, fetchurl, ... }:
stdenvNoCC.mkDerivation rec {
  pname = "sarasa-term-sc-nerd";
  version = "v1.1.0";
  src = fetchurl {
    url = "https://github.com/laishulu/Sarasa-Term-SC-Nerd/releases/download/${version}/sarasa-term-sc-nerd.ttf.tar.gz";
    sha256 = "sha256-ADS5KTYQMTELd8MjAE+ugEwC5Gr8qDpN5kPirvgogAc=";
  };
  sourceRoot = ".";
  buildPhase = ''
    runHook preBuild
    ls *.ttf
    runHook postBuild
  '';
  installPhase = ''
    runHook preInstall
    find -name \*.ttf -exec mkdir -p $out/share/fonts/truetype/ScNerd \; -exec mv {} $out/share/fonts/truetype/ScNerd \;
    runHook postInstall
  '';
}
