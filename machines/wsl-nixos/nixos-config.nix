# Configuration for the WSL NixOS. Home-manager configuration is integrated in
# this file, since there is no need to support multiple users in WSL.
{
  pkgs,
  homeManagerModule,
  myVars,
  ...
}:
let
  username = "rbj";

  # Home-manager configuration.
  userConfig =
    { pkgs, ... }:
    {
      imports = [
        homeManagerModule
      ];
      myModules = {
        git.enable = true;
        zsh = {
          enable = true;
          dotDir = ".config/zsh";
          plugins = [
            "zsh-syntax-highlighting"
            "zsh-autosuggestions"
            "zsh-completions"
          ];
        };
        fzf.enable = true;
        z-lua = {
          enable = true;
          enableAliases = true;
        };
      };

      programs.git = {
        userName = myVars.me.userFullName;
        userEmail = myVars.me.userEmail;
      };

      programs.starship = {
        enable = true;
        enableZshIntegration = true;
        enableBashIntegration = true;
      };

      xdg.configFile."starship.toml".source = ./text/starship.toml;

      systemd.user.enable = false;

      home.stateVersion = "24.05";
    };
in
{
  # WSL options.
  wsl.enable = true;
  wsl.defaultUser = username;   # This user will be created.

  networking.hostName = "nixos-wsl";

  nix.settings = {
    experimental-features = "nix-command flakes";
    substituters = [
      "https://cache.nixos.org"
      # "https://mirror.sjtu.edu.cn/nix-channels/store"
    ];
  };

  environment.systemPackages = with pkgs; [
    git
    gnumake
  ];

  programs.zsh = {
    enable = true;
    enableGlobalCompInit = false;
    promptInit = "";
  };

  programs.bash = {
    interactiveShellInit = ''
      export HISTFILE="$HOME/.bash_history"
    '';
  };

  users.users."${username}" = {
    shell = pkgs.zsh;
    uid = 1000;
  };

  home-manager.users."${username}" = userConfig;

  systemd.tmpfiles.rules =
    let
      channels = pkgs.runCommand "default-channels" { } ''
        mkdir -p $out
        ln -s ${pkgs.path} $out/nixos
      '';
    in
    [
      "L /nix/var/nix/profiles/per-user/root/channels-1-link - - - - ${channels}"
      "L /nix/var/nix/profiles/per-user/root/channels - - - - channels-1-link"
    ];

  system.stateVersion = "24.05";
}
