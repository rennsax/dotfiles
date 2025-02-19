{
  nix-vscode-extensions,
  ...
}:
[
  (final: prev: {
    sarasa-term-sc-nerd = prev.callPackage ./sarasa-term-sc-nerd.nix { };
    gnu-coding-standards = prev.callPackage ./gnu-coding-standards.nix { };
    macos-trash = prev.callPackage ./macos-trash.nix { };
    vistafonts-chs = prev.vistafonts-chs.overrideAttrs (old: {
      src = prev.fetchurl {
        # url = "https://web.archive.org/web/20161221192937if_/http://download.microsoft.com/download/d/6/e/d6e2ff26-5821-4f35-a18b-78c963b1535d/VistaFont_CHS.EXE";
        # Alternative mirror:
        url = "http://www.eeo.cn/download/font/VistaFont_CHS.EXE";
        sha256 = "1qwm30b8aq9piyqv07hv8b5bac9ms40rsdf8pwix5dyk8020i8xi";
      };
    });
    # REVIEW: remove this until new version (>0.46.1) is released.
    rlwrap = prev.rlwrap.overrideAttrs (old: {
      version = "66052c1";
      src = prev.fetchFromGitHub {
        owner = "hanslub42";
        repo = "rlwrap";
        rev = "66052c118ad0aee7db483689487901bc9f536fbc";
        sha256 = "sha256-wUjREVa8Mxe3PVZDAjO25upXfPlGE+UaLPI6a8DqazY=";
      };
    });
    hammerspoon-macos = prev.callPackage ./harmmerspoon.nix { };

    nix-vscode-extensions = nix-vscode-extensions.extensions.${final.hostPlatform.system};

    math-preview =
      let
        nodejs = final.nodejs_20;
      in
      prev.math-preview.override {
        inherit nodejs;
        buildNpmPackage = final.buildNpmPackage.override {
          inherit nodejs;
        };
      };
  })
]
