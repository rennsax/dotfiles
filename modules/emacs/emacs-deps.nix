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

          emacs-lsp-booster # This should be borrowed from an overlay.

          math-preview
          ghostscript
          pandoc

          myEmacs
        ];
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

  ]);
}
