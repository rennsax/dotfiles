{
  lib,
  fetchurl,
}:
let
  hashes = {
    zsh = "sha256-IOkIE7oaFwPN8F33JKBC185phXJz6TPQQR/ufysg8J8=";
    bash = "sha256-yHVNnDW8JJNL56sgc1ZRyaAZvStELr+0HZED5i6VxbA=";
    fish = "sha256-olJrKdyVdFBx89S56+S39bLLw63zAD8ecEGsE3Rzsyc=";
  };
  shells = builtins.attrNames hashes;
  siFor =
    shell:
    fetchurl rec {
      pname = "iterm2-${shell}-integration";
      version = "3.7.4";
      url = "https://gitlab.com/gnachman/iterm2/-/raw/v${version}/Resources/shell_integration/iterm2_shell_integration.${shell}";
      hash = hashes.${shell};
    };
in
builtins.listToAttrs (map (shell: lib.nameValuePair shell (siFor shell)) shells)
