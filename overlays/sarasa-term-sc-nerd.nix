{ stdenvNoCC, fetchurl }:
stdenvNoCC.mkDerivation rec {
  pname = "sarasa-term-sc-nerd";
  version = "2.1.1";
  src = fetchurl {
    url = "https://github.com/laishulu/Sarasa-Term-SC-Nerd/releases/download/v${version}/SarasaTermSCNerd.ttf.tar.gz";
    sha256 = "sha256-NExIIOQ0Xh5iMfYi8JQ9lavE9vT7CGOi09AKdiSJBLI=";
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
