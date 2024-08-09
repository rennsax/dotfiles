final: prev: {
  gn = prev.gn.overrideAttrs (old: {
    installPhase = ''
      ${old.installPhase}
      install -vD misc/emacs/gn-mode.el $out/share/emacs/site-lisp/gn-mode.el
    '';
  });
}
