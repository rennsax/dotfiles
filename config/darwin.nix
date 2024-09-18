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
    # On Darwin, nano is the alias of pico.
    nano
    gawk

    gnugrep
    gnused
    findutils
    diffutils
    coreutils-prefixed

    darwin.iproute2mac
    openssh
  ];

  environment.variables = {
    # I hate these two defaults ‐ they override my envs that are set before a shell is spawned.
    # https://github.com/LnL7/nix-darwin/blob/91010a5613ffd7ee23ee9263213157a1c422b705/modules/environment/default.nix#L184-L185
    EDITOR = "$EDITOR";
    PAGER = "$PAGER";
  };

  users.users.${myVars.me.username}.shell = pkgs.zsh;

  # GNU Bash is preinstalled on NixOS, so this option is only meaningful for Darwin.
  programs.bash.enable = true;

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
