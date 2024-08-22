{
  config,
  pkgs,
  lib,
  myVars,
  homeVariant,
  ...
}:
{
  home.packages =
    with pkgs;
    [
      (writeShellApplication {
        name = "nhs"; # nix home switch
        text = ''
          cd "${myVars.nixConfigDir}" || ( printf "Error cd to the Nix config directory!" >&2; exit 1)
          make home HOME_VARIANT="''${1:-${homeVariant}}"
        '';
      })
    ]
    ++ lib.optionals myVars.isDarwin [

      (writeShellApplication {
        name = "nds"; # nix darwin switch
        text = ''
          cd "${myVars.nixConfigDir}" || ( printf "Error cd to the Nix config directory!" >&2; exit 1)
          make darwin
        '';
      })

      (writeShellApplication {
        name = "mdfind-wrapper";
        text = ''
          # Remove annoying warning of mdfind.
          # See https://www.reddit.com/r/MacOS/comments/zq36l1/whats_up_with_mdfind_warning_on_console
          /usr/bin/mdfind "$@" 2> >(grep --invert-match ' \[UserQueryParser\] ' >&2)
        '';
      })
    ];

}
