# Configurations for the server of lab, Ubuntu 20.04.6, 112 CPU cores.
{
  nixpkgs,
  home-manager,
  homeManagerModule,
  nixFlakeRegistryModule,
  myVars,
}:
let
  system = "x86_64-linux";
  userModule =
    {
      lib,
      pkgs,
      ...
    }:
    let
      inherit (myVars.me) username userFullName userEmail;
    in
    {
      nix.package = pkgs.nix;
      nix.settings = {
        experimental-features = "nix-command flakes";
        substituters = [
          "https://mirror.sjtu.edu.cn/nix-channels/store"
          "https://cuda-maintainers.cachix.org"
        ];
      };
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
        emacs-libvterm.enableZshIntegration = true;
        fzf.enable = true;
        z-lua = {
          enable = true;
          enableAliases = true;
        };
        iterm2 = {
          enable = true;
          enableInstall = false;
        };
      };

      home.username = username;
      home.homeDirectory = "/home/${username}";
      xdg.enable = true;

      programs.git = {
        userName = userFullName;
        userEmail = userEmail;
      };

      home.packages = with pkgs; [
        bat
        htop
        fd
        trash-cli
        tree
        ripgrep
      ];

      programs.man = {
        enable = true;
        package = pkgs.man; # nongnu man-db
      };

      programs.starship = {
        enable = true;
        enableZshIntegration = true;
        enableBashIntegration = true;
      };

      programs.direnv = {
        enable = true;
        nix-direnv.enable = true;
      };

      xdg.configFile."starship.toml".source = ./text/starship.toml;

      programs.home-manager.enable = true;

      systemd.user.enable = false;

      home.stateVersion = "24.05";
    };
in
{
  homeConfigurations.renbj = home-manager.lib.homeManagerConfiguration {
    pkgs = nixpkgs.legacyPackages.${system};
    modules = [
      nixFlakeRegistryModule
      homeManagerModule
      userModule
    ];
  };
}
