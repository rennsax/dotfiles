RLS	:= sonoma					# the default release name
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

system := $(arch)-$(kernel)
REBUILD := $(kernel)-rebuild

$(info Current System = "$(system)")
$(info Patch vars...)
$(shell ./scripts/patch-vars)

all: $(kernel) home

test:
	@echo $(NIX_ARGS)

nix-darwin := github:LnL7/nix-darwin/50581970f37f06a4719001735828519925ef8310
home-manager := github:nix-community/home-manager/1a4f12ae0bda877ec4099b429cf439aad897d7e9

init-darwin:
	nix $(NIX_ARGS) run $(nix-darwin) -- switch --flake .#$(RLS)
	nix $(NIX_ARGS) run 'flake:nixpkgs#home-manager' -- switch --flake .#$(system)

init-home:
	nix $(NIX_ARGS) run $(home-manager) -- switch --flake .#$(system)

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
