{
  pkgs,
  inputs,
  myVars,
  ...
}:
{
  imports = [
    # Include the general configs, shared with NixOS.
    ./general.nix
  ];

  nix.registry = {
    nix-darwin.flake = inputs.nix-darwin;
  };

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  security.pam.enableSudoTouchIdAuth = true;

  system.defaults.finder = {
    AppleShowAllExtensions = true;
    AppleShowAllFiles = false; # Do not always show hidden files

    FXPreferredViewStyle = "Nlsv";
    ShowStatusBar = false;

    FXDefaultSearchScope = "SCcf"; # default to current folder

    ShowPathbar = true; # path breadcrumbs
    _FXShowPosixPathInTitle = false; # fullpath in the title
  };

  environment.systemPackages = with pkgs; [
    gawk

    gnugrep
    gnused
    findutils
    diffutils
    coreutils-prefixed

    darwin.iproute2mac
    openssh
  ];

  users.users.${myVars.me.username}.shell = pkgs.zsh;

  # GNU Bash is preinstalled on NixOS, so this option is only meaningful for Darwin.
  programs.bash.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
