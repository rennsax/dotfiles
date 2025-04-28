{
  pkgs,
  ...
}:
{
  launchd.agents."gnupg-agent" = {
    enable = true;
    config = {
      ProgramArguments = [
        "${pkgs.gnupg}/bin/gpg-connect-agent"
        "/bye"
      ];
      RunAtLoad = true;
      KeepAlive.SuccessfulExit = false;
    };
  };

  programs.zsh.initContent = ''
    # Bind gpg-agent to this TTY if gpg commands are used.
    export GPG_TTY=$(tty)

    # SSH agent protocol doesn't support changing TTYs, so bind the agent
    # to every new TTY.
    ${pkgs.gnupg}/bin/gpg-connect-agent --quiet updatestartuptty /bye > /dev/null

    export SSH_AUTH_SOCK=$(${pkgs.gnupg}/bin/gpgconf --list-dirs agent-ssh-socket)
  '';
}
