# Extra piecemeal dotfiles.
# Type: plugin.
{ ... }:
{
  home.file = {
    ".gdbinit".text = ''
      set disassembly-flavor intel
    '';
  };
}
