# Home-manager configuration for 501 user.
{
  config,
  pkgs,
  lib,
  myVars,
  nur-rennsax-pkgs,
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

  nixpkgs.config.allowUnfree = true;

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
    tmux.oh-my-tmux.enable = true;
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
  home.packages =
    with pkgs;
    let
      fontPackages = [
        nerd-fonts.monaspace
        nerd-fonts.fira-code
        nerd-fonts.caskaydia-cove

        lxgw-wenkai
        source-han-serif
        source-han-sans
        sarasa-term-sc-nerd # overlay
        vistafonts-chs # Microsoft Yahei
      ];
      displayline = runCommandLocal "displayline" { } ''
        mkdir -p $out/bin
        ln -s ${skimpdf}/Applications/Skim.app/Contents/SharedSupport/displayline $out/bin/displayline
      '';
    in
    [
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
      iproute2mac

      # TeX tools
      texliveFull
      skimpdf
      displayline

      # Programming
      shellcheck
      nixfmt-rfc-style

      (python313.withPackages (
        ps: with ps; [
          pip
          build
          ipython
        ]
      ))

      (vscode-with-extensions.override {
        vscodeExtensions =
          # Almost latest extensions, but sometimes requires VS Code with higher version.
          (with nix-vscode-extensions; [
            vscode-marketplace.vivaxy.vscode-conventional-commits
            vscode-marketplace.cschlosser.doxdocgen
          ])
          ++
            # Extensions managed by Nixpkgs.
            (with vscode-extensions; [
              tuttieee.emacs-mcx

              pkief.material-icon-theme
              gruntfuggly.todo-tree

              streetsidesoftware.code-spell-checker
              usernamehw.errorlens
              timonwong.shellcheck

              # Languages
              jnoortheen.nix-ide

              # Killer APPs of VS Code.
              ms-vscode-remote.remote-ssh
              ms-vscode-remote.remote-ssh-edit

              ms-python.python
              ms-toolsai.jupyter

              eamodio.gitlens
            ]);
      })

      hammerspoon-macos

      gnupg

      nur-rennsax-pkgs.osx-org-protocol-client
    ]
    ++ fontPackages;

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
    # `DIRENV_LOG_FORMAT` seems to only be applied if the config file actually
    # is found, see:
    # https://github.com/direnv/direnv/issues/1418#issuecomment-2820125413
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

    "direnv/direnv.toml".text = "";
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
