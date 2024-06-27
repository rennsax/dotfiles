RLS	= sonoma					# the default release name
T =
NIX_ARGS = --extra-experimental-features 'nix-command flakes'

all: darwin home

init-darwin:
	nix $(NIX_ARGS) run nix-darwin switch --flake .#$(RLS)
	nix $(NIX_ARGS) run nixpkgs#home-manager switch --flake .#default

darwin:
	darwin-rebuild switch --flake .#$(RLS)

list:
	darwin-rebuild switch --list-generations

gen:
	darwin-rebuild switch --switch-generation $(T)

size:
	@du -sh /nix

# Why sudo again? See https://github.com/LnL7/nix-darwin/issues/237#issuecomment-716021555
clean:
	nix-collect-garbage --delete-older-than 14d
	sudo nix-collect-garbage --delete-older-than 14d

home:
	home-manager switch --flake	.#default

.PHONY:	all install	darwin list gen size clean home
