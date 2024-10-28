# Home-manager configuration for 501 user.
{
  config,
  pkgs,
  lib,
  myVars,
  ...
}:
let
  inherit (myVars.me) username userFullName userEmail;
in
{
  imports = [
    ./orbstack-shell.nix
    ./gnupg-agent.nix
  ];

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
  };

  # home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = username;
  home.homeDirectory = "/Users/${username}";

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
    cheat
    openssh

    # Programming
    shellcheck
    nixfmt-rfc-style

    (python3.withPackages (
      ps: with ps; [
        pip
        build
        ipython
      ]
    ))

    hammerspoon-macos

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

    ".hammerspoon/init.lua".source = ./text/hammerspoon-init.lua;
    ".hammerspoon/Spoons/ReloadConfiguration.spoon".source = pkgs.fetchzip {
      url = "https://github.com/Hammerspoon/Spoons/raw/master/Spoons/ReloadConfiguration.spoon.zip";
      hash = "sha256-kNyFHP3i1O4VhZQL2Ief6002TrvXzT4doZ9w8X5z6C0=";
    };
  };

  xdg.configFile = {
    "pip/pip.conf".text = ''
      [global]
      index-url = https://pypi.tuna.tsinghua.edu.cn/simple
    '';

    "cheat/conf.yml".source =
      with pkgs;
      let
        communityCheatsheets = fetchFromGitHub {
          owner = "cheat";
          repo = "cheatsheets";
          rev = "36bdb99";
          sha256 = "sha256-Afv0rPlYTCsyWvYx8UObKs6Me8IOH5Cv5u4fO38J8ns=";
        };

      in
      replaceVars ./text/cheat-conf.yml.in {
        inherit communityCheatsheets;
        personalCheatsheets = "${config.xdg.configHome}/cheat/personal";
        bat = "${bat}/bin/bat";
      };
  };

  targets.darwin.defaults =
    {
      "org.gpgtools.pinentry-mac".DisableKeychain = true;
    }
    //
    # Turn off Microsoft Office Telemetry.
    builtins.listToAttrs (
      map
        (
          app:
          lib.nameValuePair "com.microsoft.${app}" {
            SendAllTelemetryEnabled = false;
          }
        )
        [
          "Word"
          "Excel"
          "Powerpoint"
          "Outlook"
          "autoupdate2"
          "Office365ServiceV2"
          "onenote.mac"
        ]
    );

  programs.home-manager.enable = true;

  home.stateVersion = "24.05";
}
