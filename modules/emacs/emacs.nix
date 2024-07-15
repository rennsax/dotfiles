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
in
with lib;
{
  options.myModules.emacs = {
    enable = mkEnableOption "emacs";
  };
  config = mkIf cfg.enable {
    home.packages =
      with pkgs;
      [
        emacs-lsp-booster
        math-preview
        ghostscript
      ]
      ++ optionals myVars.isDarwin [
        pngpaste # for org-download
        libreoffice-bin
        (writeShellApplication {
          name = "soffice-cli";
          text = ''
            ${libreoffice-bin}/Applications/LibreOffice.app/Contents/MacOS/soffice "$@"
          '';
        })
      ];
  };
}
