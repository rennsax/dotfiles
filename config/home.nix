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
  myModules = {
    starship.enable = true;
    cheat.enable = true;
    git.enable = true;
    zsh = {
      enable = true;
      dotDir = ".config/zsh"; # Should follow $ZDOTDIR
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

    (writeShellApplication {
      name = "nds"; # nix darwin switch
      text = ''
        cd "${myVars.nixConfigDir}" || ( printf "Error cd to the Nix config directory!" >&2; exit 1)
        make darwin
      '';
    })

    (writeShellApplication {
      name = "nhs"; # nix home switch
      text = ''
        cd "${myVars.nixConfigDir}" || ( printf "Error cd to the Nix config directory!" >&2; exit 1)
        make home
      '';
    })

    # FIXME: macOS specified
    (writeShellApplication {
      name = "mdfind-wrapper";
      text = ''
        # Remove annoying warning of mdfind.
        # See https://www.reddit.com/r/MacOS/comments/zq36l1/whats_up_with_mdfind_warning_on_console
        /usr/bin/mdfind "$@" 2> >(grep --invert-match ' \[UserQueryParser\] ' >&2)
      '';
    })
  ];

  home.language = {
    base = "en_US.UTF-8";
  };
  home.sessionVariables = {
    EDITOR =
      let
        name = "editor-wrapper";
      in
      pkgs.writeShellApplication {
        inherit name;
        text = ''
          if ! command -v emacsclient >/dev/null 2>&1; then
              # cannot find Emacs
              nvim "$@"
          else
              # Try Emacs, if not found, use nvim.
              emacsclient -c -q -a nvim "$@"
          fi
        '';
      }
      + "/bin/${name}";
    GOPATH = "${config.xdg.dataHome}/go";
    GOMODCACHE = "${config.xdg.cacheHome}/go/mod";
  };

  # dotfiles that do not conform to XDG standard.
  home.file = {
    ".gdbinit".text = ''
      set disassembly-flavor intel
    '';
  };

  # Will pollute `home.sessionVariables`
  xdg.enable = true;

  programs.man = {
    enable = true;
    generateCaches = true;
    package = pkgs.man; # nongnu man-db
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
