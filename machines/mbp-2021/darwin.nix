{
  pkgs,
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

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Set your time zone.
  time.timeZone = "Asia/Shanghai";

  # Fonts
  fonts.packages = with pkgs; [
    (nerdfonts.override {
      fonts = [
        "Monaspace"
        "FiraCode"
        "CascadiaCode"
      ];
    })
    lxgw-wenkai
    source-han-serif
    source-han-sans
    sarasa-term-sc-nerd # overlay
    vistafonts-chs # Microsoft Yahei
  ];

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

  environment.systemPackages = with pkgs; [
    vim
    gnumake

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

  # FIXME: this seems to reply on my personal module.
  # users.users.${myVars.me.username}.shell = pkgs.zsh;

  # GNU Bash is preinstalled on NixOS, so this option is only meaningful for Darwin.
  programs.bash.enable = true;

  # REVIEW: remove this after upgrading to macOS 15 Sequoia.
  ids.uids.nixbld = 300;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

}
