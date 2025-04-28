{
  pkgs,
  lib,
  config,
  ...
}:
# Simplified zsh module that satisfies my personal usage.
with lib;
let
  inherit (pkgs.stdenv.hostPlatform) isDarwin;
  cfg = config.myModules.zsh;

  pluginsDir = cfg.dotDir + "/.zsh-plugins";

  pluginsMeta = import ./plugins-meta.nix { inherit pkgs; };

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

  zdotDir = "$HOME/" + cfg.dotDir;

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
  };

  config = mkIf cfg.enable (mkMerge [
    {
      programs.zsh = {
        enable = true;
        package = cfg.package;
        enableCompletion = true;
        completionInit = ''
          () {
            emulate -L zsh
            setopt extendedglob
            autoload -U compinit

            # Speed up zsh compinit by only checking cache once a day.
            # See https://gist.github.com/ctechols/ca1035271ad134841284
            if [[ -n ''${ZDOTDIR:-$HOME}/.zcompdump(#qN.mh+24) ]]; then
              compinit
            else
              # -C: omit the check for the number of completion files.
              compinit -C
            fi
          }
        '';
        initExtraBeforeCompInit =
          ''
            ############################################################
            #################### BEGIN my configs ######################
            ############################################################

            ${readFile ./config/zshrc-extra}

            ############################################################
            ####################  END my configs  ######################
            ############################################################
          '';
        inherit (cfg) dotDir;

        # Regrettably, I cannot disable home-manager from modifying my history settings.
        history = {
          path = "${config.xdg.stateHome}/zsh/zsh_history";
          size = 1000000;
          save = 1000000;
          extended = true;
          ignoreDups = true;
          ignoreAllDups = false;
          ignoreSpace = true;
          expireDuplicatesFirst = true;
          share = true;
        };

        initExtra = ''
          [ -f "${zdotDir}/.zshrc-temp" ] && source "${zdotDir}/.zshrc-temp"
        '';

        initExtraFirst = ''
          plugins=(${concatStringsSep " " cfg.plugins})
        '';
      };
    }

    {
      # Explicitly set the default value for the history file of Bash, so it
      # won't corrupt the zsh history when Bash is invoked as the subshell.
      programs.bash.historyFile = mkDefault "${config.home.homeDirectory}/.bash_history";
    }

    (mkIf config.programs.z-lua.enable {

      programs.zsh.initExtra = mkAfter ''
        ${pkgs.z-lua}/bin/z.lua --add "$PWD"
      '';

    })

    # Link plugins to config directory.
    (mkIf (cfg.plugins != [ ]) {
      home.file = foldl' (a: b: a // b) { } (
        map (plugin: { "${pluginsDir}/${plugin.name}".source = plugin.src; }) installedPlugins
      );
    })

  ]);
}
