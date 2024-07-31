{ config, lib, ... }:

with lib;
let
  cfg = config.system.defaults.uikit;
in
{
  options.system.defaults.uikit = {
    redesigned_text_cursor = mkOption {
      type = types.nullOr types.bool;
      default = null;
      description = ''
        When switching IME/Capslock, whether to show a floating UI indicating the change.
      '';
    };
  };

  config = mkIf (cfg.redesigned_text_cursor != null) {
    # https://stackoverflow.com/questions/77248249
    system.activationScripts.defaults.text = ''
      defaults write /Library/Preferences/FeatureFlags/Domain/UIKit.plist redesigned_text_cursor -dict-add Enabled -bool ${
        if cfg.redesigned_text_cursor then "YES" else "NO"
      }
    '';
  };
}
