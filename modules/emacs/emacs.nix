{
  pkgs,
  lib,
  config,
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
    home.packages = with pkgs; [
      emacs-lsp-booster
      math-preview
      ghostscript
    ] ++ optionals stdenv.hostPlatform.isDarwin [
      pngpaste                  # for org-download
      libreoffice-bin
      (
        let
          version = libreoffice-bin.version;
        in
        writeShellApplication {
          name = "soffice-cli";
          text = ''
            ${libreoffice-bin}/Applications/LibreOffice.app/Contents/MacOS/soffice "$@"
          '';
        }
      )
    ];
  };
}
