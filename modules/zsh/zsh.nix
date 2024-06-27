{
  pkgs,
  lib,
  config,
  myLib,
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
      # Disable the home-manager's zsh module.
      programs.zsh.enable = mkForce false;
      home.packages = [ cfg.package ];
      myModules.zsh.plugins = optional cfg.defer.enable "zsh-defer";
    }

    # Link plugins to config directory.
    (mkIf (cfg.plugins != [ ]) {
      home.file = foldl' (a: b: a // b) { } (
        map (plugin: { "${pluginsDir}/${plugin.name}".source = plugin.src; }) installedPlugins
      );
    })

    (mkIf (cfg._personalConfigs.enable) {
      home.file = foldl' (a: b: a // b) { } (
        map (filename: { "${cfg.dotDir}/${filename}".source = ./config/${filename}; }) (
          builtins.attrNames (builtins.readDir ./config)
        )
      );
    })
  ]);
}
