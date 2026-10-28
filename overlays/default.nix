{
  nix-vscode-extensions,
  ...
}:
[
  (final: prev: {
    sarasa-term-sc-nerd = prev.callPackage ./sarasa-term-sc-nerd.nix { };
    gnu-coding-standards = prev.callPackage ./gnu-coding-standards.nix { };
    macos-trash = prev.callPackage ./macos-trash.nix { };
    hammerspoon-macos = prev.callPackage ./hammerspoon.nix { };
  })
  nix-vscode-extensions.overlays.default
]
