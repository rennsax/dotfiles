{
  pkgs,
  lib,
  config,
  myVars,
  ...
}:
let
  cfg = config.myModules.emacs;
in
with lib;
{
  options.myModules.emacs = {
    enable = mkEnableOption "emacs";
  };
  config = mkIf cfg.enable (mkMerge [
    # Generic dependencies.
    {
      home.packages =
        with pkgs;
        let
          myEmacs = emacs29.override {
            # Already default to true.
            # withNativeCompile = true;
            # withImageMagick = true;
          };
        in
        [
          ripgrep
          fd

          emacs-lsp-booster

          math-preview
          ghostscript
          pandoc

          aspellDicts.en

          myEmacs
        ];

      # So that enchant-2 and aspell can find installed dictionaries.
      # REVIEW: why this patch does not take effects? https://github.com/NixOS/nixpkgs/blob/ad0b5eed1b6031efaed382844806550c3dcb4206/pkgs/development/libraries/aspell/default.nix#L30
      home.file.".aspell.conf".text = ''
        dict-dir ${config.home.profileDirectory}/lib/aspell
      '';
    }

    # macOS dependencies.
    (optionalAttrs myVars.isDarwin {
      home.packages =
        with pkgs;
        let
          macism = callPackage ./macism.nix { };
          soffice-cli = callPackage ./soffice-cli.nix { };
        in
        [
          pngpaste
          libreoffice-bin
          soffice-cli
          macism
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
