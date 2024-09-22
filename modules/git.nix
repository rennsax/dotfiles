{
  pkgs,
  lib,
  config,
  myVars,
  ...
}:

let
  cfg = config.myModules.git;
in
with myVars.me;
{
  options.myModules.git = {
    enable = lib.mkEnableOption "git";
    signingConfig = lib.mkEnableOption "default signing configurations";
  };

  config = lib.mkIf cfg.enable {
    programs.git = {
      enable = true;
      userName = userFullName;
      userEmail = userEmail;
      package = pkgs.gitAndTools.gitFull;

      aliases = {
        a = "add";
        co = "checkout";
        br = "branch";
        ci = "commit";
        st = "status";
        amend = "commit --amend";
        ls = "log --graph --pretty=\"%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset\"";
        lss = "ls --stat";
        lsa = "ls --all";
        mff = "!mff() { git merge --ff-only \"$1\" && git reset --hard HEAD@{1} && git merge --no-ff \"$1\"; }; mff";
        dft = "difftool";
      };

      signing = lib.mkIf cfg.signingConfig {
        gpgPath = "${pkgs.writeShellScript "gpg-loopback-wrapper" ''
          ${pkgs.gnupg}/bin/gpg --pinentry-mode loopback "$@"
        ''}";
        # Must be explicitly defined.
        key = null;
      };

      lfs = {
        enable = true;
        skipSmudge = true;
      };

      difftastic = {
        enable = true;
      };
      extraConfig = {
        core = {
          ignorecase = false;
        };
        github = {
          user = "rennsax";
        };
        init.defaultBranch = "main";
      };

      ignores = [
        ".DS_Store"
        ".DS_Store?"
        "*.swp"
        "._*"
        ".Spotlight-V100"
        ".Trashes"
        "Icon?"
        "ehthumbs.db"
        "Thumbs.db"
        "*.7z"
        "*.dmg"
        "*.gz"
        "*.iso"
        "*.jar"
        "*.rar"
        "*.tar"
        "*.zip"
        ".direnv"
      ];
    };
  };
}
