install-nix:
	@command -v nix >/dev/null 2>&1 || curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install --no-confirm

init-ubuntu: install-nix
	./scripts/init-ubuntu

size:
	@sudo du -sh /nix

.PHONY: install-nix init-ubuntu size
