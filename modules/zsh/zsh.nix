{
  pkgs,
  lib,
  config,
  myLib,
  myVars,
  ...
}:
# Simplified zsh module that satisfies my personal usage.
with lib;
let
  cfg = config.myModules.zsh;

  pluginsDir = cfg.dotDir + "/.zsh-plugins";

  pluginsMeta = import ./plugins-meta.nix { inherit myLib pkgs; };

  installedPlugins =
    map (
      plugin:
      assert assertMsg (builtins.hasAttr plugin pluginsMeta) "${plugin} is not a known plugin!";
      { name = plugin; } // pluginsMeta.${plugin}
    ) cfg.plugins
    ++ map (plugin: rec {
      name = plugin;
      src = ./site-plugins/${name};
    }) cfg.extraPlugins;

  zdotDir = "$HOME/" + escapeShellArg cfg.dotDir;

  zshDataDir = "${config.xdg.dataHome}/zsh";

in
{
  options.myModules.zsh = {
    enable = mkEnableOption "zsh";
    dotDir = mkOption {
      default = ".config/zsh";
      type = types.str;
    };
    package = mkPackageOption pkgs "zsh" { };
    plugins = mkOption {
      default = [ ];
      type = types.listOf types.str;
    };
    extraPlugins = mkOption {
      default = [ ];
      type = types.listOf types.str;
      description = "Extra Zsh plugins, most of which are created by myself. See modules/zsh/site-plugins.";
    };
    defer = {
      enable = mkEnableOption "zsh-defer";
    };
    _personalConfigs.enable = mkEnableOption "my personal zsh configs";

  };

  config = mkIf cfg.enable (mkMerge [
    {
      programs.zsh = {
        enable = true;
        package = cfg.package;
        enableCompletion = true;
        initExtraBeforeCompInit =
          ''
            ############################################################
            #################### BEGIN my configs ######################
            ############################################################

          ''
          + (concatStringsSep "\n" (
            [ (readFile ./config/.zshrc-extra) ] ++ optional myVars.isDarwin (readFile ./config/.zshrc-darwin)
          ))
          + ''

            ############################################################
            ####################  END my configs  ######################
            ############################################################
          '';
        inherit (cfg) dotDir;

        # Regrettably, I cannot disable home-manager from modifying my history settings.
        history = {
          path = "${zshDataDir}/zsh_history";
          size = 1000000;
          save = 1000000;
          ignorePatterns = [ "*${myVars.me.username}*" ];
          extended = true;
          ignoreDups = true;
          ignoreAllDups = false;
          ignoreSpace = true;
          expireDuplicatesFirst = true;
          share = true;
        };
      };
      myModules.zsh.plugins = optional cfg.defer.enable "zsh-defer";
    }

    # Link plugins to config directory.
    (mkIf (cfg.plugins != [ ]) {
      home.file = foldl' (a: b: a // b) { } (
        map (plugin: { "${pluginsDir}/${plugin.name}".source = plugin.src; }) installedPlugins
      );
    })

  ]);
}
