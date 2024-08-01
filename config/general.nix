# General configs for {nixos,darwin}Configurations.

{
  config,
  pkgs,
  inputs,
  ...
}:
{
  nix.package = pkgs.nix;

  nix.settings = {
    experimental-features = "nix-command flakes";
    substituters = [
      # Use `--option substitute false` to disable querying from the cache server.
      "https://mirror.sjtu.edu.cn/nix-channels/store"
      # "https://mirrors.ustc.edu.cn/nix-channels/store"
      # "https://nix-community.cachix.org"

      # It's added by default.
      # "https://cache.nixos.org"
    ];
  };

  nix.registry = {
    nixpkgs.flake = inputs.nixpkgs;
    flake-utils.flake = inputs.flake-utils;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = false;

  environment.systemPackages = with pkgs; [
    vim
    gnumake
  ];

  # Set your time zone.
  time.timeZone = "Asia/Shanghai";

  # Fonts
  fonts.packages = with pkgs; [
    (nerdfonts.override {
      fonts = [
        "Monaspace"
        "FiraCode"
      ];
    })
    lxgw-wenkai
    source-han-serif
    source-han-sans
    sarasa-term-sc-nerd # overlay
  ];

  programs.zsh = {
    enable = true;
    # These two tremendously slow down my shell.
    enableGlobalCompInit = false;
    enableBashCompletion = false;
    promptInit = "";
  };

  programs.bash = {
    # So the bash history does not corrupt the zsh history, if it's invoked as subshell.
    interactiveShellInit = ''
      export HISTFILE="$HOME/.bash_history"
    '';
  };

}
