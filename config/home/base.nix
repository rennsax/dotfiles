# Basic home configurations. Satisfy my daily workflow.
# Type: slot.
{
  pkgs,
  myVars,
  ...
}:
{
  myModules = {
    starship.enable = true;
    cheat.enable = true;
    cheat._enableEditableCheatsheets = true;
    git.enable = true;
    zsh = {
      enable = true;
      dotDir = ".config/zsh";
      defer.enable = true;
      extraPlugins = [ "vterm" ];
      plugins = [
        "zsh-syntax-highlighting"
        "zsh-autosuggestions"
        "zsh-completions"
        "tmux"
        "git"
        "orb"
      ];
    };
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

  home.packages =
    with pkgs;
    [
      bat
      curl
      dust
      fd
      htop
      ripgrep
      tree
      rlwrap # Readline wrapper
      p7zip
      wget
      jq
    ]
    ++ lib.optionals myVars.isDarwin [
      (stdenvNoCC.mkDerivation {
        pname = "macos-trash";
        version = "v1.2.0";
        src = fetchurl {
          url = "https://github.com/sindresorhus/macos-trash/releases/download/v1.2.0/trash.zip";
          hash = "sha256-hJc2rFosV+LQfXnf4ssagfpLaShFho/ths2HJ6t1tzw=";
        };
        # If not specified, unpackPhase tries to move cwd to the single
        # directory, which leads to error.
        sourceRoot = ".";
        nativeBuildInputs = [ unzip ];
        installPhase = ''
          runHook preInstall
          mkdir -p $out/bin
          cp trash $out/bin/
          runHook postInstall
        '';
      })
    ]
    ++ lib.optionals myVars.isLinux [ trash-cli ];

  home.extraOutputsToInstall = [
    "info"
    "man"
  ];

  programs.man = {
    enable = true;
    generateCaches = true;
    package = pkgs.man; # nongnu man-db
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.zsh.sessionVariables = {
    # Disable regular load/unload messages.
    DIRENV_LOG_FORMAT = "";
  };

}
