{
  lib,
  fetchurl,
}:
let
  hashes = {
    zsh = "sha256-kQJ8bVIh7nEjYJ6OWqiEDqIY+YWD5RbD1CXV+KKyDno=";
    bash = "sha256-gHSOANRhOVHLjFSzPZNG2GQ0xlFkLt5P277jwWYGgs8=";
    fish = "sha256-aKTt7HRMlB7htADkeMavWuPJOQq1EHf27dEIjKgQgo0=";
  };
  shells = builtins.attrNames hashes;
  siFor =
    shell:
    fetchurl rec {
      pname = "iterm2-${shell}-integration";
      version = "3.5.11";
      url = "https://gitlab.com/gnachman/iterm2/-/raw/v${version}/Resources/shell_integration/iterm2_shell_integration.${shell}";
      hash = hashes.${shell};
    };
in
builtins.listToAttrs (map (shell: lib.nameValuePair shell (siFor shell)) shells)
