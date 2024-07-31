{ ... }: [
  (import ./cheat-fix-zsh-completion.nix)
  (final: prev: {
    sarasa-term-sc-nerd = prev.callPackage ./sarasa-term-sc-nerd.nix { };
  })
]
