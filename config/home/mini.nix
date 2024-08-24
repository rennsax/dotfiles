# Minimal home configurations. Only covers necessary tools.
# Type: slot.
{
  pkgs,
  lib,
  ...
}:
{
  myModules = {
    starship.enable = true;
    fzf.enable = true;
    z-lua = {
      enable = true;
      enableAliases = true;
    };
    iterm2 = {
      enable = true;
      enableInstall = lib.mkDefault false;
    };
  };

  home.packages = with pkgs; [
    bat
    htop
    fd
    tree
    ripgrep
  ];

  programs.man = {
    enable = true;
    generateCaches = true;
    package = pkgs.man; # nongnu man-db
  };
}
