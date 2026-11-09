{
  config,
  lib,
  pkgs,
  homeManagerModule,
  myVars,
  ...
}:
let
  username = "rbj";
in
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;

  hardware.enableRedistributableFirmware = true;
  zramSwap.enable = true;

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    trusted-users = [ username ];
  };

  networking.hostName = "rennsax-rpi4"; # Define your hostname.

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Shanghai";

  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    ripgrep
  ];

  programs.bash = {
    interactiveShellInit = ''
      export HISTFILE="$HOME/.bash_history"
    '';
  };

  programs.zsh = {
    enable = true;
    # These two tremendously slow down my shell.
    enableGlobalCompInit = false;
    enableBashCompletion = false;
    promptInit = "";
  };

  programs.nix-ld.enable = true;

  services.openssh.enable = true;

  users.groups = {
    "${username}" = { };
    hs-deck = { };
  };

  users.users."${username}" = {
    uid = 1000;
    openssh.authorizedKeys.keys = [
      myVars.me.publicKey
    ];
    isNormalUser = true;
    group = username;
    extraGroups = [
      "wheel"
      "hs-deck"
    ];
    shell = pkgs.zsh;
  };

  systemd.services.db-backup = {
    description = "Backup SQLite database";
    wantedBy = [ "multi-user.target" ];
    path = [
      pkgs.sqlite
      pkgs.gzip
      pkgs.findutils
      pkgs.coreutils
    ];
    script = builtins.readFile ./services/backup-db.sh;
    serviceConfig = {
      Type = "oneshot";
      User = "root";
      Group = "hs-deck";
    };
  };

  systemd.timers.db-backup = {
    description = "Backup SQLite database every 12 hours";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "*-*-* 00,12:00:00";
      Persistent = true;
      Unit = "db-backup.service";
    };
  };

  systemd.tmpfiles.rules = [
    "d /var/backups/hs_deck_bot_db 0750 root hs-deck -"
  ];

  system.stateVersion = "26.11";

  home-manager.users."${username}" = {
    imports = [
      homeManagerModule
      ({
        myModules = {
          git.enable = true;
          zsh = {
            enable = true;
            plugins = [
              "zsh-syntax-highlighting"
              "zsh-autosuggestions"
              "zsh-completions"
            ];
          };
          tmux.enable = true;
          tmux.oh-my-tmux.enable = true;
        };
        programs.starship.enable = true;
        xdg.configFile."starship.toml".source = ../lab-workstation/text/starship.toml;
        home.stateVersion = "26.05";
      })
      ({
        programs.git.settings.user = with myVars.me; {
          name = userFullName;
          email = userEmail;
        };
      })
    ];
  };

}
