# Extra piecemeal plain-text configuration files.
# Type: plugin.
{ ... }:
{
  home.file = {
    ".gdbinit".text = ''
      set disassembly-flavor intel
    '';
  };
}
