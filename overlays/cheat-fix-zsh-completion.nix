final: prev: {
  cheat = prev.cheat.overrideAttrs (old: {
    patches = (old.patches or [ ]) ++ [ ./patches/cheat.zsh.patch ];
  });
}
