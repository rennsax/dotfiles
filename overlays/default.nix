{ ... }: [
  (final: prev: {
    cheat = prev.cheat.overrideAttrs (old: {
      patches = (old.patches or [ ]) ++ [ ./patches/cheat.zsh.patch ];
    });
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
  })
]
