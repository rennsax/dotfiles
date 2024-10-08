{
  pkgs,
  lib,
  config,
  ...
}:
with lib;
let
  cfg = config.myModules.hammerspoon;

  hsCask = pkgs.callPackage ./hs-cask.nix { };
in
{
  options.myModules.hammerspoon = {
    enable = mkEnableOption "hammerspoon";
  };

  config = mkIf cfg.enable {
    home.packages = [ hsCask ];
    home.file.".hammerspoon/init.lua".source = ./config/init.lua;
    home.file.".hammerspoon/Spoons/ReloadConfiguration.spoon".source = pkgs.stdenvNoCC.mkDerivation {
      name = "ReloadConfiguration.spoon";
      nativeBuildInputs = [ pkgs.unzip ];
      src = pkgs.fetchurl {
        url = "https://github.com/Hammerspoon/Spoons/raw/master/Spoons/ReloadConfiguration.spoon.zip";
        hash = "sha256-w8Dyzt/xtGbC3SvNMAAJMUPUt7ElgeTBf5WuPjfgGiI=";
      };
      installPhase = ''
        runHook preInstall
        mkdir -p $out
        cp init.lua docs.json $out/
        runHook postInstall
      '';
    };
  };

}
