{ writeShellApplication, libreoffice-bin, ... }:
writeShellApplication {
  name = "soffice-cli";
  text = ''
    ${libreoffice-bin}/Applications/LibreOffice.app/Contents/MacOS/soffice "$@"
  '';
}
