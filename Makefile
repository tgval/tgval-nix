# Makefile — absolute symlinks for dotfiles, helix, cinnamon, and per-machine NixOS hardware config

# Automatically determine the repo directory (this Makefile's location)
GIT_DIR := $(realpath $(dir $(abspath $(lastword $(MAKEFILE_LIST)))))

# Default machine (can be overridden)
MACHINE ?= legion

# Default target
all: link

link:
	@echo "Using GIT_DIR: $(GIT_DIR)"
	@echo "Setting up configuration for machine: $(MACHINE)"
	@echo "Linking user configuration files..."
	mkdir -p $(HOME)/.config/cinnamon
	ln -sfn $(GIT_DIR)/cinnamon $(HOME)/.config/cinnamon
	ln -sfn $(GIT_DIR)/.vimrc $(HOME)/.vimrc
	ln -sfn $(GIT_DIR)/.bashrc $(HOME)/.bashrc
	mkdir -p $(HOME)/.config/helix
	ln -sfn $(GIT_DIR)/helix-config.toml $(HOME)/.config/helix/config.toml

	@echo "Linking NixOS configuration..."
	sudo ln -sfn $(GIT_DIR)/nixos /etc/nixos

	@echo "Linking hardware configuration for machine $(MACHINE)..."
	sudo ln -sfn $(GIT_DIR)/machines/$(MACHINE)/hardware-configuration.nix /etc/nixos/hardware-configuration.nix

	@echo "All symlinks created successfully."

.PHONY: all link

