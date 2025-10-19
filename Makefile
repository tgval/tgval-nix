# Makefile — symlinks for NixOS configuration and user dotfiles

# Automatically determine the repo directory (this Makefile's location)
GIT_DIR := $(realpath $(dir $(abspath $(lastword $(MAKEFILE_LIST)))))

# Default target: run both in order
all: link-nixos link-user

# Link NixOS configuration
link-nixos:
	@echo "Linking NixOS configuration to /etc/nixos..."
	sudo ln -sfn $(GIT_DIR)/nixos /etc/nixos
	@echo "NixOS configuration linked successfully."

# Link user dotfiles (cinnamon, helix, vim, bash)
link-user:
	@echo "Linking user configuration files..."
	mkdir -p $(HOME)/.config/cinnamon
	ln -sfn $(GIT_DIR)/cinnamon $(HOME)/.config/cinnamon
	ln -sfn $(GIT_DIR)/.vimrc $(HOME)/.vimrc
	ln -sfn $(GIT_DIR)/.bashrc $(HOME)/.bashrc
	mkdir -p $(HOME)/.config/helix
	ln -sfn $(GIT_DIR)/helix-config.toml $(HOME)/.config/helix/config.toml
	@echo "User dotfiles linked successfully."

.PHONY: all link-nixos link-user
