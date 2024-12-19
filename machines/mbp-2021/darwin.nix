{
  pkgs,
  myVars,
  lib,
  config,
  ...
}:

{
  nix.package = pkgs.nix;

  nix.settings = {
    experimental-features = "nix-command flakes";
    substituters = [
      # Use `--option substitute false` to disable querying from the cache server.
      "https://mirror.sjtu.edu.cn/nix-channels/store"
      # "https://mirrors.ustc.edu.cn/nix-channels/store"
      # "https://nix-community.cachix.org"

      # It's added by default.
      # "https://cache.nixos.org"
    ];
  };

  # For `impureEnvVars`.
  nix.envVars = {
    http_proxy = "http://127.0.0.1:8881";
    https_proxy = "http://127.0.0.1:8881";
  };

  # Set your time zone.
  time.timeZone = "Asia/Shanghai";

  programs.zsh = {
    enable = true;
    # These two tremendously slow down my shell.
    enableGlobalCompInit = false;
    enableBashCompletion = false;
    promptInit = "";
  };

  programs.bash = {
    # So the bash history does not corrupt the zsh history, if it's invoked as subshell.
    interactiveShellInit = ''
      export HISTFILE="$HOME/.bash_history"
    '';
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

  system.defaults.NSGlobalDomain = {
    ApplePressAndHoldEnabled = false;
  };

  # Collection of my defaults commands.
  system.activationScripts.defaults.text = ''
    # Fn: Change input source.
    defaults write com.apple.HIToolbox AppleFnUsageType -int "1"

    # Do not show input source switch popup.
    # https://stackoverflow.com/questions/77248249
    defaults write kCFPreferencesAnyApplication TSMLanguageIndicatorEnabled 0
  '';

  environment.systemPackages = with pkgs; [
    vim
    gnumake

    # On Darwin, nano is the alias of pico.
    nano
    gawk
    less

    gnugrep
    gnused
    findutils
    diffutils
    coreutils-prefixed

    darwin.iproute2mac
  ];

  environment.variables = {
    # I hate these two defaults ‐ they override my envs that are set before a shell is spawned.
    # https://github.com/LnL7/nix-darwin/blob/91010a5613ffd7ee23ee9263213157a1c422b705/modules/environment/default.nix#L184-L185
    EDITOR = "$EDITOR";
    PAGER = "$PAGER";
  };

  assertions = [
    {
      assertion = config.programs.zsh.enable;
      message = ''
        Options `programs.zsh.enable` must be enabled because I set Zsh as the
        default shell. See also https://github.com/NixOS/nixpkgs/blob/bf171746655a97d46cc7a1037749d9e2f15e5889/nixos/modules/config/users-groups.nix#L926-L937.
      '';
    }
  ];

  # Explicitly set my default shell.
  # Check https://github.com/NixOS/nixpkgs/blob/e495f07011d1d044f35b71c3b4eddbe4826f3534/nixos/lib/utils.nix#L113-L120
  #   for the logic of extracting shell path.
  system.activationScripts.users.text = ''
    dscl . -create '/Users/${myVars.me.username}' UserShell ${lib.escapeShellArg ("/run/current-system/sw${pkgs.zsh.shellPath}")}
  '';

  # GNU Bash is preinstalled on NixOS, so this option is only meaningful for Darwin.
  programs.bash.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

}
