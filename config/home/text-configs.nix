# Extra piecemeal plain-text configuration files.
# Type: plugin.
{ ... }:
{
  home.file = {
    ".gdbinit".text = ''
      set disassembly-flavor intel
    '';
  };

  xdg.configFile = {
    "pip/pip.conf".text = ''
      [global]
      index-url = https://pypi.tuna.tsinghua.edu.cn/simple
    '';
  };
}
