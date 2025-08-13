{
  pkgs,
  lib,
  homeManagerModule,
  myVars,
  ...
}:
let
  username = "rbj";
in
{
  imports = [ ./hardware-configuration.nix ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nix.settings = {
    experimental-features = "nix-command flakes";
  };

  time.timeZone = "Asia/Shanghai";

  networking.networkmanager.enable = true;
  networking.hostName = "rennsax-nixos";
  services.openssh.enable = true;

  programs.zsh = {
    enable = true;
    # These two tremendously slow down my shell.
    enableGlobalCompInit = false;
    enableBashCompletion = false;
    promptInit = "";
  };

  environment.systemPackages = with pkgs; [
    git
    curl
    wget
    htop
    vim
    gnumake
    file
  ];

  system.stateVersion = "25.05";

  # User configurations.

  users.groups."${username}" = { };
  users.users."${username}" = {
    shell = pkgs.zsh;
    uid = 1000;
    openssh.authorizedKeys.keys = [
      myVars.me.publicKey
    ];
    isNormalUser = true;
    group = username;
    extraGroups = [ "wheel" ];
  };

  home-manager.users."${username}" = {
    imports = [
      ./user-config.nix
      homeManagerModule
      ({
        programs.git = with myVars.me; {
          userName = userFullName;
          userEmail = userEmail;
        };
      })
    ];
  };
}
