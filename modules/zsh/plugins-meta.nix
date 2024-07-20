{ myLib, pkgs }:
with pkgs;
{
  "zsh-syntax-highlighting" = {
    src = fetchFromGitHub {
      owner = "zsh-users";
      repo = "zsh-syntax-highlighting";
      rev = "e0165eaa730dd0fa321a6a6de74f092fe87630b0";
      sha256 = "sha256-4rW2N+ankAH4sA6Sa5mr9IKsdAg7WTgrmyqJ2V1vygQ=";
    };
  };
  "zsh-autosuggestions" = {
    src = fetchFromGitHub {
      owner = "zsh-users";
      repo = "zsh-autosuggestions";
      rev = "c3d4e576c9c86eac62884bd47c01f6faed043fc5";
      sha256 = "sha256-B+Kz3B7d97CM/3ztpQyVkE6EfMipVF8Y4HJNfSRXHtU=";
    };
  };
  "zsh-completions" = {
    src = fetchFromGitHub {
      owner = "zsh-users";
      repo = "zsh-completions";
      rev = "507f1f8715edd9f1f403c140fa332644d81ebab5";
      sha256 = "sha256-8qgANoYAvTlAnyKcOfHATEAWvvPzztIcRVmTHWcEM5c=";
    };
  };
  # I prefer to manage z.lua as a Zsh plugin, rather than a standalone binary.
  "z.lua" = {
    src = fetchFromGitHub {
      owner = "skywind3000";
      repo = "z.lua";
      rev = "7c890c3645081014eab4be2ab45e8640f86f62d7";
      sha256 = "sha256-XhkwS6qQJUwS5yHh3KDnpkWK6uekpM2fysx1rsiLtAc=";
    };
  };
  "tmux" = {
    src = myLib.mkCombinedDir {
      name = "ohmyzsh-tmux";
      files = [
        {
          name = "tmux.plugin.zsh";
          src = pkgs.fetchurl {
            url = "https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/tmux/tmux.plugin.zsh";
            sha256 = "sha256-Y3Mp0rS9LkYCfaigD67Tuu2T6VcRcrajBGoKG5ihfo8=";
          };
        }
      ];
    };
  };
  "git" = {
    src = myLib.mkCombinedDir {
      name = "ohmyzsh-git";
      files = [
        {
          name = "git.plugin.zsh";
          src = pkgs.fetchurl {
            url = "https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/lib/git.zsh";
            sha256 = "sha256-K+XfERH3+4yCZ43M8gBnid22jVyoItNwStukn5y5aYk=";
          };
        }
      ];
    };
  };
  "orb" = {
    src = myLib.mkCombinedDir {
      name = "orb-zsh";
      files = [
        {
          name = "orb.plugin.zsh";
          src = pkgs.fetchurl {
            url = "https://raw.githubusercontent.com/orbstack/orbstack/main/orb.plugin.zsh";
            sha256 = "sha256-NuAIlCVOfzpaURbTvdbrRdAzaNpL2RDkrhZ8bkrrR44=";
          };
        }
      ];
    };
  };
  "cheat" = {
    src = myLib.mkCombinedDir {
      name = "zsh-cheat-completion";
      files = [
        {
          name = "cheat.plugin.zsh";
          src = pkgs.fetchurl {
            url = "https://raw.githubusercontent.com/cheat/cheat/master/scripts/cheat.zsh";
            sha256 = "sha256-eCEHQoL925PSH4pUTAWOqMuwy2jO6e8QSdaTqnbkOBE=";
          };
        }
      ];
    };
  };
  "zsh-defer" = {
    src = fetchFromGitHub {
      owner = "romkatv";
      repo = "zsh-defer";
      rev = "53a26e287fbbe2dcebb3aa1801546c6de32416fa";
      sha256 = "sha256-MFlvAnPCknSgkW3RFA8pfxMZZS/JbyF3aMsJj9uHHVU=";
    };
  };
}
