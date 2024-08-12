T :=
NIX_ARGS := --extra-experimental-features 'nix-command flakes'
HOME_VARIANT := worker

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
all: nixos home

else ifeq ($(kernel),darwin)

REBUILD := darwin-rebuild
all: darwin home

endif

SYSTEM := $(arch)-$(kernel)

$(info Current system = "$(SYSTEM)")

test:
	@echo Rebuild command: $(REBUILD)

NIX-DARWIN := github:LnL7/nix-darwin/ec12b88104d6c117871fad55e931addac4626756
HOME-MANAGER := github:nix-community/home-manager/0a30138c694ab3b048ac300794c2eb599dc40266

init-ubuntu: patch-vars install-nix
	./scripts/init-ubuntu

init-nixos: patch-vars nixos

init-darwin: patch-vars
	nix $(NIX_ARGS) run $(NIX-DARWIN) -- switch --flake .#$(RLS)

init-home: patch-vars
	nix $(NIX_ARGS) run $(HOME-MANAGER) -- switch --flake .#$(HOME_VARIANT)-$(SYSTEM)

patch-vars:
	@echo "Patch vars..."
	@./scripts/patch-vars
	@echo "Initialization done."

darwin:
	$(REBUILD) switch --flake .#sonoma

install-nix:
	@command -v nix >/dev/null 2>&1 || curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install --no-confirm

nixos:
	@echo "Generating NixOS hardware configuration..."
	@nixos-generate-config --show-hardware-config > ./config/hardware-configuration.nix
	@git add --intent-to-add ./config/hardware-configuration.nix
	$(REBUILD) switch --flake .#nixos

home:
	home-manager switch --flake	.#$(HOME_VARIANT)-$(SYSTEM)

list:
	$(REBUILD) switch --list-generations

gen:
	$(REBUILD) switch --switch-generation $(T)

size:
	@sudo du -sh /nix

# Why sudo again? See https://github.com/LnL7/nix-darwin/issues/237#issuecomment-716021555
clean:
	nix-collect-garbage --delete-older-than 14d
	sudo nix-collect-garbage --delete-older-than 14d

.PHONY:	all init-darwin	darwin list gen size clean home init-nixos nixos test init-ubuntu patch-vars
