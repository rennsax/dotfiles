# Fix https://github.com/LnL7/nix-darwin/issues/984#issuecomment-2193798885
# Nix-darwin uses dscl(1) to change the default shell, e.g.
#
#   sudo dscl . -create /Users/<name> UserShell <shellpath>.
#
# However, nix-darwin won't try to update the user shell until you list the user
# in `users.knownUsers`. To change the user shell, nix-darwin uses (though
# unnecessarily) `users.users.<name>.uid` as well. So to update the user shell,
# you also need to specify the uid, which is weird.
#
# In my implementation, just declare `users.users.<name>.shell` is enough. If
# you also list the user in `users.knownUsers`, make sure its uid is specified
# (and you may not need this module), or nix-darwin will throw errors.
#
# NOTE: chsh(1) is OK for changing the login shell too. But it only accepts a
# shell that is listed in /etc/shells (standard shell, terminologically).
{
  config,
  lib,
  pkgs,
  ...
}:
with lib;

let
  cfg = config.users;
  users = filterAttrs (u: v: v.shell != null) cfg.users;
  userShells = mapAttrs (u: v: v.shell) users;

  # convert a valid argument to user.shell into a string that points to a shell
  # executable. Logic copied from modules/system/shells.nix.
  shellPath = v: if types.shellPackage.check v then "/run/current-system/sw${v.shellPath}" else v;
in
{
  config = {
    system.activationScripts.users.text = ''
      printf >&2 "setting up user shells...\n"

      ${concatStringsSep "\n" (
        mapAttrsToList (u: s: ''
          u=$(dscl . -read '/Users/${u}' UniqueID 2> /dev/null) || true
          if [ -z "$u" ]; then
            printf >&2 "[1;31mwarning: user '${u}' does not exist![0m\n"
          else
            dscl . -create '/Users/${u}' UserShell ${lib.escapeShellArg (shellPath s)}
          fi
        '') userShells
      )}
    '';
  };
}
