{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  inherit (pkgs.stdenv.hostPlatform) isDarwin;
  cfg = config.myModules.darwinSetup;
  needSetup = cfg.enable && cfg.scripts != "";
in
{
  options.myModules.darwinSetup = {
    enable = mkEnableOption "Extra setup scripts for darwin" // {
      default = isDarwin;
    };
    scripts = mkOption {
      type = types.str;
      default = "";
    };
  };

  config = mkMerge [
    {
      assertions = [
        {
          assertion = needSetup -> isDarwin;
          message = "Must use Darwin for myModules.darwinSetup!";
        }
      ];
    }

    (mkIf needSetup {
      home.activation.darwinSetup = hm.dag.entryAfter [ "writeBoundary" ] cfg.scripts;
    })
  ];
}
