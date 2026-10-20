{ config, lib, ... }:

let
  stateHome = config.xdg.stateHome;
in
{
  home.sessionVariables = {
    MYSQL_HISTFILE = "${stateHome}/mysql_history";
    NODE_REPL_HISTORY = "${stateHome}/node_repl_history";
    PYTHON_HISTORY = "${stateHome}/python/history";
  };
  home.activation.createXdgDirectories = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    run mkdir -p "${stateHome}/python"
  '';
}
