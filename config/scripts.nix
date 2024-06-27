{
  config,
  pkgs,
  lib,
  myVars,
  ...
}:
{
  home.packages =
    with pkgs;
    [
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

    ]
    ++ lib.optional stdenv.hostPlatform.isDarwin (writeShellApplication {
      name = "mdfind-wrapper";
      text = ''
        # Remove annoying warning of mdfind.
        # See https://www.reddit.com/r/MacOS/comments/zq36l1/whats_up_with_mdfind_warning_on_console
        /usr/bin/mdfind "$@" 2> >(grep --invert-match ' \[UserQueryParser\] ' >&2)
      '';
    });
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
  };

}
