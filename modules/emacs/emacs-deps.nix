{
  pkgs,
  lib,
  config,
  myVars,
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

  # Extract one file from src of DRV. FROM is a relative path for the file to extract.
  # TO is a directory prefix to which the file should be copied to.
  extractFileFromSrc =
    {
      drv,
      from,
      to,
    }:
    let
      getBase = p: last (path.subpath.components p);
      filename = getBase from;
    in
    pkgs.stdenvNoCC.mkDerivation {
      pname = filename;
      version = getVersion drv;
      inherit (drv) src;
      phases = "unpackPhase installPhase";
      installPhase = ''
        install -vDt $out/${to} ${from}
      '';
    };

  mkSiteLisp =
    drv: from:
    (extractFileFromSrc {
      inherit drv from;
      to = "share/emacs/site-lisp";
    });
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
        (mkSiteLisp cmake "Auxiliary/cmake-mode.el")
        (mkSiteLisp gn "misc/emacs/gn-mode.el")
        (callPackage ./emacs-clang-tools.nix llvmPackages)
      ];
    }

    # macOS dependencies.
    (optionalAttrs myVars.isDarwin {
      home.packages =
        with pkgs;
        let
          macism = callPackage ./macism.nix { };
          soffice-cli = callPackage ./soffice-cli.nix { };
          org-protocol-client = callPackage ./osx-org-protocol-client.nix { emacs = myEmacs; };
        in
        [
          pngpaste
          libreoffice-bin
          soffice-cli
          macism
          org-protocol-client
        ];
    })

    {
      programs.zsh.shellAliases =
        {
          emacs-kill-server = "emacsclient -e '(save-buffers-kill-emacs)'";
        }
        // optionalAttrs (config.myModules.tmux.enable || config.programs.tmux.enable) {
          emacs-client = "tmux new-session -s \"emacs-client\" -d emacsclient -c -a emacs";
        };

      home.sessionPath = mkAfter [ "${config.xdg.configHome}/emacs/bin" ];
    }

  ]);
}
