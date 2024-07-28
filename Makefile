T :=
NIX_ARGS := --extra-experimental-features 'nix-command flakes'

uname_m := $(shell uname -m)
uname_s := $(shell uname -s)

ifeq ($(uname_m),arm64)
arch := aarch64
else ifeq ($(uname_m),aarch64)
arch := aarch64
else ifeq ($(uname_m),x86_64)
arch := x86_64
endif

ifeq ($(uname_s),Darwin)
kernel := darwin
else ifeq ($(uname_s),Linux)
kernel := linux
endif

ifeq ($(kernel),linux)

REBUILD := sudo nixos-rebuild
RLS	:= nixos
all: nixos home

else ifeq ($(kernel),darwin)

REBUILD := darwin-rebuild
RLS	:= sonoma
all: darwin home

endif

SYSTEM := $(arch)-$(kernel)

$(info Current system = "$(SYSTEM)")
$(info Patch vars...)
$(shell ./scripts/patch-vars)
$(info Initialization done.)

test:
	@echo Rebuild command: $(REBUILD)

NIX-DARWIN := github:LnL7/nix-darwin/ec12b88104d6c117871fad55e931addac4626756
HOME-MANAGER := github:nix-community/home-manager/0a30138c694ab3b048ac300794c2eb599dc40266

init-darwin:
	nix $(NIX_ARGS) run $(NIX-DARWIN) -- switch --flake .#$(RLS)
	nix $(NIX_ARGS) run 'flake:nixpkgs#home-manager' -- switch --flake .#$(SYSTEM)

init-home:
	nix $(NIX_ARGS) run $(HOME-MANAGER) -- switch --flake .#$(SYSTEM)

darwin:
	$(REBUILD) switch --flake .#$(RLS)

nixos:
	@echo "Generating NixOS configuration..."
	@nixos-generate-config --dir ./config
	$(REBUILD) switch --flake .#$(RLS)

list:
	$(REBUILD) switch --list-generations

gen:
	$(REBUILD) switch --switch-generation $(T)

size:
	@du -sh /nix

# Why sudo again? See https://github.com/LnL7/nix-darwin/issues/237#issuecomment-716021555
clean:
	nix-collect-garbage --delete-older-than 14d
	sudo nix-collect-garbage --delete-older-than 14d

home:
	home-manager switch --flake	.#$(SYSTEM)

.PHONY:	all init-darwin	darwin list gen size clean home
