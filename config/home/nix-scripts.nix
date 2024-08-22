# Extra scripts for easily switching between Nix configurations.
# Type: plugin.
{
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

    ];
}
