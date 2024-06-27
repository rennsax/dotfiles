{
  inputs, # Flake input
  config,
  pkgs,
  lib,
  myVars,
  myLib,
  ...
}:

let
  username = myVars.me.username;
in
{
  imports = [ ./scripts.nix ./dotfiles.nix ];
  myModules = {
    starship.enable = true;
    cheat.enable = true;
    git.enable = true;
    zsh = {
      enable = true;
      dotDir = ".config/zsh";
      _personalConfigs.enable = true;
      defer.enable = true;
      extraPlugins = [
        "vterm"
        "nnn-quitcd"
      ];
      plugins = [
        "zsh-syntax-highlighting"
        "zsh-autosuggestions"
        "zsh-completions"
        "z.lua"
        "tmux"
        "git"
        "orb"
      ];
    };
    fzf.enable = true;
    tmux.enable = true;
    hammerspoon.enable = true;
  };

  nix.registry.home-manager = {
    flake = inputs.home-manager;
  };

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = username;
  home.homeDirectory =
    if pkgs.stdenv.hostPlatform.isDarwin then "/Users/${username}" else "/home/${username}";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    bat
    btop
    dust
    fd
    jq
    gh
    ripgrep
    nixfmt-rfc-style
    tree

  ];

  home.language = {
    base = "en_US.UTF-8";
  };
  home.sessionVariables = {
    # macOS: `systemsetup -listtimezones`
    TZ = "Asia/Shanghai";
    # REVIEW: purely manage npm config
    NPM_CONFIG_USERCONFIG = "${config.xdg.configHome}/npm/npmrc";
    GOPATH = "${config.xdg.dataHome}/go";
    GOMODCACHE = "${config.xdg.cacheHome}/go/mod";

    http_proxy = myVars.network.proxy.clash;
    https_proxy = myVars.network.proxy.clash;
  };

  # Will pollute `home.sessionVariables`
  xdg.enable = true;

  programs.man = {
    enable = true;
    generateCaches = true;
    package = pkgs.man; # nongnu man-db
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };
  programs.zsh.sessionVariables = {
    # Disable regular load/unload messages.
    DIRENV_LOG_FORMAT = "";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
