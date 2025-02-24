# Tmux configurations based on gpakosz/.tmux
{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
  # Whether to disable plugin system.
  disablePlugin ? false,
}:

stdenvNoCC.mkDerivation {
  name = "tmux-conf";
  src = fetchFromGitHub {
    owner = "gpakosz";
    repo = ".tmux";
    rev = "babf1c1fc611d28c3f2c3710c494b4e23a77ba72";
    sha256 = "sha256-tSfpHxH+emz0F5bXICfVXv0IOLrvNh01rdbOTT8Qemc=";
  };
  dontBuild = true;
  installPhase = ''
    mkdir -p $out
    cp .tmux.conf $out/tmux.conf
    cp ${./tmux.conf.local} $out/tmux.conf.local
  '';
  patches = lib.optional disablePlugin (
    builtins.toFile "oh-my-tmux-disable-plugin.patch" ''
      diff --git a/.tmux.conf b/.tmux.conf
      index a19df11..dcf13cb 100644
      --- a/.tmux.conf
      +++ b/.tmux.conf
      @@ -1873,7 +1873,6 @@ run 'cut -c3- "$TMUX_CONF" | sh -s _apply_configuration'
       #   _apply_bindings&
       #   wait
       #
      -#   _apply_plugins
       #   _apply_important
       #
       #   # shellcheck disable=SC2046
    ''
  );
}
