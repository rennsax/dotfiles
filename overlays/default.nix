{ ... }: [
  (import ./cheat-fix-zsh-completion.nix)
  (final: prev: {
    sarasa-term-sc-nerd = prev.callPackage ./sarasa-term-sc-nerd.nix { };
    gnu-coding-standards = prev.callPackage ./gnu-coding-standards.nix { };
    macos-trash = prev.callPackage ./macos-trash.nix { };
  })
]
