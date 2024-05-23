[![GitHub Actions Workflow Status](https://img.shields.io/github/actions/workflow/status/rennsax/dotfiles/test-install.yml?label=Test)](https://github.com/rennsax/dotfiles/actions/workflows/test-install.yml)

# dotfiles

My personal dotfiles.

Designed to be cross-platform, but mainly tested on macOS (MacBook Pro 2021).

## Modules

- [asdf](https://github.com/asdf-vm/asdf)
  - [asdf-java (personal fork)](https://github.com/rennsax/asdf-java)
- [cheat](https://github.com/cheat/cheat): my personal cheatsheets.
- cpp-dev: init files for GNU GDB and LLVM tools.
- [iTerm2](https://iterm2.com/)
- [nnn (personal fork)](https://github.com/rennsax/nnn)
- [npm](https://www.npmjs.com/)
- [nvim](https://github.com/neovim/neovim)
- [pet](https://github.com/knqyf263/pet)
- [starship](https://starship.rs/): terminal prompt.
- [tmux](https://github.com/tmux/tmux): based on [gpakosz/.tmux: 🇫🇷 Oh my tmux!](https://github.com/gpakosz/.tmux).
- [yabai](https://github.com/koekeishiya/yabai) (deprecated): tilling window manager for macOS
- [zsh](https://github.com/zsh-users/zsh)

## Installation

**Not well-tested. Use with caution!**

```sh
git submodule update --remote --recursive

## These two scripts must be run at the root directory.
## And I recommend set the environment variable to see more logs, if there are
## some problems.
## See the documents in the corresponding scripts, such as install-debian.sh.
# export INSTALL_DEBIAN_TRACE=1
./scripts/install.sh
./scripts/init-dotfiles.sh
```

## TODO

- [ ] script: install fonts.

## References

- [XDG Base Directory - ArchWiki](https://wiki.archlinux.org/title/XDG_Base_Directory)
- [zsh-intro.pdf](https://www.ecb.torontomu.ca/guides/zsh-intro.pdf)
- [Configuring Zsh Without Dependencies](https://thevaluable.dev/zsh-install-configure-mouseless/)
- [Zsh Plugin Standard](https://zdharma-continuum.github.io/Zsh-100-Commits-Club/Zsh-Plugin-Standard.html)
- [How To Use A Tiling Window Manager On MacOs | Yabai Ultimate Guide](https://www.youtube.com/watch?v=k94qImbFKWE)
