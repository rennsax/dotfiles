{
  lib,
  fetchurl,
}:
let
  hashes = {
    zsh = "sha256-kQJ8bVIh7nEjYJ6OWqiEDqIY+YWD5RbD1CXV+KKyDno=";
    bash = "sha256-v9G7xQtts7QDdctlwPpRbPcRvk+TYndLHDX9BbHxW5o=";
    fish = "sha256-++OLTyOdf0yxeub0DuzIPwu1Ois/zcDal+YvzD3Sjvk=";
  };
  shells = builtins.attrNames hashes;
  siFor =
    shell:
    fetchurl rec {
      pname = "iterm2-${shell}-integration";
      version = "3.6.10";
      url = "https://gitlab.com/gnachman/iterm2/-/raw/v${version}/Resources/shell_integration/iterm2_shell_integration.${shell}";
      hash = hashes.${shell};
    };
in
builtins.listToAttrs (map (shell: lib.nameValuePair shell (siFor shell)) shells)
