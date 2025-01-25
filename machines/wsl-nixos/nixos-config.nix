# Configuration for the WSL NixOS.
{ pkgs, ... }:
{
  wsl.enable = true;
  wsl.defaultUser = "nixos";

  nix.settings = {
    experimental-features = "nix-command flakes";
    substituters = [
      "https://mirror.sjtu.edu.cn/nix-channels/store"
    ];
  };

  environment.systemPackages = with pkgs; [
    git
    gnumake
  ];

  programs.zsh = {
    enable = true;
    enableGlobalCompInit = false;
    promptInit = "";
  };

  programs.bash = {
    interactiveShellInit = ''
      export HISTFILE="$HOME/.bash_history"
    '';
  };

  users.users = {
    rbj = {
      isNormalUser = true;
      shell = pkgs.zsh;
      extraGroups = [ "wheel" ];
    };
  };

  system.stateVersion = "24.05";
}
