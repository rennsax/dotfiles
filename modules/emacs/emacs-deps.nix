{
  pkgs,
  lib,
  config,
  ...
}:
with lib;
let
  cfg = config.myModules.emacs;
  myEmacs = pkgs.emacs29.override {
    # Already default to true.
    # withNativeCompile = true;
    # withImageMagick = true;
  };

in
{
  config = mkIf cfg.enable (mkMerge [
    # Generic dependencies.
    {
      home.packages = with pkgs; [
        ripgrep
        fd

        emacs-lsp-booster

        math-preview
        ghostscript
        pandoc

        imagemagick

        aspellDicts.en

        nodePackages.prettier

        universal-ctags

        # Nix LSP
        nil

        myEmacs
      ];

      # So that enchant-2 and aspell can find installed dictionaries.
      # REVIEW: why this patch does not take effects? https://github.com/NixOS/nixpkgs/blob/ad0b5eed1b6031efaed382844806550c3dcb4206/pkgs/development/libraries/aspell/default.nix#L30
      home.file.".aspell.conf".text = ''
        dict-dir ${config.home.profileDirectory}/lib/aspell
      '';

    }

    # Dynamic modules
    {
      home.packages =
        with pkgs;
        let
          jinx-mod = callPackage ./jinx-mod.nix { };
          vterm-module = callPackage ./vterm-module.nix { };
        in
        [
          jinx-mod
          vterm-module
        ];
    }

    # Lisp files extract from sources.
    {
      home.packages = with pkgs; [
        emacsPackages.gn-mode-from-sources
        emacsPackages.cmake-mode
      ];
    }

    # macOS dependencies.
    {
      home.packages = mkIf pkgs.stdenv.hostPlatform.isDarwin (
        with pkgs;
        let
          macism = callPackage ./macism.nix { };
          soffice-cli = writeShellApplication {
            name = "soffice-cli";
            text = ''
              ${libreoffice-bin}/Applications/LibreOffice.app/Contents/MacOS/soffice "$@"
            '';
          };
        in
        [
          pngpaste
          soffice-cli
          macism
        ]
      );
    }

    {
      programs.zsh.shellAliases = {
        emacs-kill-server = "emacsclient -e '(save-buffers-kill-emacs)'";
      };

      home.sessionPath = mkAfter [ "${config.xdg.configHome}/emacs/bin" ];
    }

  ]);
}
