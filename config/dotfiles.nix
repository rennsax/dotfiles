{
  config,
  pkgs,
  lib,
  ...
}:

{
  home.file = {
    ".gdbinit".text = ''
      set disassembly-flavor intel
    '';
  };
}
