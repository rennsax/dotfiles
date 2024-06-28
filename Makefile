RLS	:= sonoma					# the default release name
T :=
NIX_ARGS := --extra-experimental-features 'nix-command flakes'

nixpkgs_path := "github:NixOS/nixpkgs?rev=c66e98"

uname_m := $(shell uname -m)
uname_s := $(shell uname -s)

ifeq "$(uname_m)" "arm64"
arch := aarch64
else
arch := x86_64
endif

ifeq "$(uname_s)" "Darwin"
kernel := darwin
else
kernel := linux
endif

system := $(arch)-$(kernel)
REBUILD := $(kernel)-rebuild

$(info Current System = "$(system)")

all: $(kernel) home

nixpkgs := 'github:NixOS/nixpkgs?rev=c66e984bda09e7230ea7b364e677c5ba4f0d36d0'
override-input-arg := --override-input nixpkgs $(nixpkgs)
nix-darwin := 'github:LnL7/nix-darwin?rev=50581970f37f06a4719001735828519925ef8310'

test:
	@echo $(NIX_ARGS)

init-darwin:
	nix $(NIX_ARGS) run $(nix-darwin) $(override-input-arg) -- switch --flake .#$(RLS)
	nix $(NIX_ARGS) run 'flake:nixpkgs#home-manager' $(override-input-arg) -- switch --flake .#$(system)

darwin:
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
	home-manager switch --flake	.#$(system)

.PHONY:	all init-darwin	darwin list gen size clean home
