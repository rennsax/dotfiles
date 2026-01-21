{ pkgs, ... }:
{
  myModules = {
    git.enable = true;
    git.signingConfig = true;
    zsh = {
      enable = true;
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
    tmux.enable = true;
    tmux.oh-my-tmux.enable = true;
    iterm2.enable = true;
    emacs-libvterm.enableZshIntegration = true;
  };

  home.packages = with pkgs; [
    bat
    fd
    ripgrep
    tree
    rlwrap
    p7zip
    jq
    trash-cli
    nodejs
  ];

  systemd.user.services = {
    gitlab-runer = {
      Unit = {
        Description = "GitLab Runner";
        After = "network.target";
        ConditionPathExists = "/var/run/docker.sock";
      };
      Service = {
        ExecStart = "${pkgs.gitlab-runner}/bin/gitlab-runner run";
        Restart = "always";
        RestartSec = 5;
      };
    };
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.starship.enable = true;

  programs.gpg = {
    enable = true;
    settings = {
      pinentry-mode = "loopback";
    };
  };
  services.gpg-agent = {
    enable = true;
    pinentry.package = pkgs.pinentry-tty;
    enableSshSupport = true;
  };

  programs.nix-index.enable = true;

  xdg.configFile."starship.toml".source = ./text/starship.toml;

  home.stateVersion = "25.05";
}
