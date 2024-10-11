# Home-manager configuration for 501 user.
{
  pkgs,
  lib,
  myVars,
  ...
}:
let
  inherit (myVars.me) username userFullName userEmail;
in
{
  myModules = {
    git.enable = true;
    git.signingConfig = true;
    zsh = {
      enable = true;
      dotDir = ".config/zsh";
      plugins = [
        "zsh-syntax-highlighting"
        "zsh-autosuggestions"
        "zsh-completions"
      ];
    };
    emacs.enable = true;
    emacs-libvterm.enableZshIntegration = true;
    cheat.enable = true;
    cheat._personalCheatsheetsPath = "${myVars.nixConfigDir}/modules/cheat/cheatsheets/personal";
    fzf.enable = true;
    tmux.enable = true;
    z-lua = {
      enable = true;
      enableAliases = true;
    };
    iterm2.enable = true;
    xdg = {
      npm.enable = true;
      go.enable = true;
    };
    hammerspoon.enable = true;
    # NOTE: install Orbstack manually with DMG image.
    orbstack.enable = true;
  };

  # home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = username;
  home.homeDirectory =
    if pkgs.hostPlatform.isDarwin then "/Users/${username}" else "/home/${username}";

  home.sessionVariables = {
    EDITOR = lib.mkDefault "\${EDITOR:-nano}";
    PAGER = lib.mkDefault "\${PAGER:-less -iR}";
  };
  home.language = {
    base = "en_US.UTF-8";
  };
  home.packages = with pkgs; [
    bat
    curl
    dust
    fd
    htop
    ripgrep
    rsync
    tree
    rlwrap # Readline wrapper
    p7zip
    wget
    jq
    macos-trash

    # Programming
    shellcheck
    nixfmt-rfc-style

    (python3.withPackages (
      ps: with ps; [
        pip
        ipython
      ]
    ))

    gnupg
  ];

  home.extraOutputsToInstall = [
    "info"
    "man"
  ];

  # Clash proxy.
  home.sessionVariables = {
    http_proxy = "http://127.0.0.1:8881";
    https_proxy = "http://127.0.0.1:8881";
  };

  # Will pollute `home.sessionVariables`
  xdg.enable = true;

  programs.man = {
    enable = true;
    generateCaches = true;
    package = pkgs.man; # nongnu man-db
  };

  programs.git = {
    userName = userFullName;
    userEmail = userEmail;
  };

  programs.gh = {
    enable = true;
    gitCredentialHelper.enable = true;
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.zsh.sessionVariables = {
    # Disable regular load/unload messages.
    DIRENV_LOG_FORMAT = "";
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
  };

  xdg.configFile."starship.toml".source = ./text/starship.toml;

  home.file = {
    ".gdbinit".text = ''
      set disassembly-flavor intel
    '';
  };

  xdg.configFile = {
    "pip/pip.conf".text = ''
      [global]
      index-url = https://pypi.tuna.tsinghua.edu.cn/simple
    '';
  };

  # FIXME: the original home-manager is not suitable for my config structure.
  programs.home-manager.enable = true;

  home.stateVersion = "24.05";
}
