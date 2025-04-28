{
  pkgs,
  lib,
  config,
  ...
}:
with lib;
let
  cfg = config.myModules.fzf;
in
{
  options.myModules.fzf = {
    enable = mkEnableOption "fzf";
    package = mkPackageOption pkgs "fzf" { };
  };

  config = mkIf cfg.enable {
    programs.fzf = {
      enable = true;
      inherit (cfg) package;
      defaultCommand = "fd --type f --strip-cwd-prefix";
      fileWidgetCommand = "fd --type f --strip-cwd-prefix";
      changeDirWidgetCommand = "fd --type d --strip-cwd-prefix";
      changeDirWidgetOptions = [ "--preview 'tree -C {}'" ];
    };

    programs.zsh.initContent = ''
      # Extra fzf settings. Use fd for listing path candidates.
      _fzf_compgen_dir() {
          # cd **<TAB>
          fd --type d --hidden --follow --exclude ".git" --exclude "node_modules" . "$1"
      }
      _fzf_compgen_path() {
          # vim **<TAB>
          fd --hidden --follow --exclude ".git" --exclude "node_modules" . "$1"
      }
    '';
  };
}
