{ pkgs, inputs, myVars, ... }:
{
  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  nix.package = pkgs.nix;

  nix.settings = {
    # Necessary for using flakes on this system.
    experimental-features = "nix-command flakes";
    substituters = [
      # Use `--option substitute false` to disable querying from the cache server.
      "https://mirror.sjtu.edu.cn/nix-channels/store"
      # "https://mirrors.ustc.edu.cn/nix-channels/store"
      # "https://nix-community.cachix.org"
      "https://cache.nixos.org"
    ];
  };

  nix.registry = {
    nixpkgs.flake = inputs.nixpkgs;
    nix-darwin.flake = inputs.nix-darwin;
    flake-utils.flake = inputs.flake-utils;
  };

  nix.nixPath = [
    {
      nixpkgs = "${pkgs.path}";
    }
  ];

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  security.pam.enableSudoTouchIdAuth = true;

  system.defaults.finder = {
    AppleShowAllExtensions = true;
    AppleShowAllFiles = false;       # Do not always show hidden files

    FXPreferredViewStyle = "Nlsv";
    ShowStatusBar = false;

    FXDefaultSearchScope = "SCcf";   # default to current folder

    ShowPathbar = true;              # path breadcrumbs
    _FXShowPosixPathInTitle = false; # fullpath in the title
  };

  environment.systemPackages = with pkgs; [

    gnumake                          # darwin's make is old

    gnugrep
    gnused
    findutils
    diffutils
    coreutils-prefixed

    darwin.iproute2mac
  ];

  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "Monaspace" "FiraCode" ]; })
    lxgw-wenkai
    source-han-serif
    source-han-sans
  ];

  users.users.${myVars.me.username}.shell = pkgs.zsh;

  programs.zsh = {
    enable = true;
    # These two tremendously slow down my shell.
    enableGlobalCompInit = false;
    enableBashCompletion = false;
    promptInit = "";
  };

  programs.bash = {
    enable = true;
    # So the bash history does not corrupt the zsh history, if it's invoked as subshell.
    interactiveShellInit = ''
      export HISTFILE="$HOME/.bash_history"
    '';
  };
}
