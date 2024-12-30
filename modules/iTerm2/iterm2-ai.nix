{
  unzip,
  fetchurl,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation rec {
  pname = "iterm2-ai-plugin";
  version = "1.1";

  src = fetchurl {
    url = "https://iterm2.com/downloads/ai-plugin/iTermAI-${version}.zip";
    hash = "sha256-SE7k/jF2qCyQmToW0Iq4mlxbWoTo/qH0gddkTw9kp/k=";
  };

  nativeBuildInputs = [ unzip ];

  sourceRoot = ".";

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/Applications
    cp -R . $out/Applications/
    runHook postInstall
  '';
}
