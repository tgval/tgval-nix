# Makefile — create absolute symbolic links for configuration files and NixOS setup

# Automatically determine the absolute path to the git repo (this Makefile's directory)
GIT_DIR := $(realpath $(dir $(abspath $(lastword $(MAKEFILE_LIST)))))

# Default target
all: link

# Create symbolic links using absolute paths
link:
	@echo "Using GIT_DIR: $(GIT_DIR)"
	@echo "Linking configuration files..."
	mkdir -p $(HOME)/.config/cinnamon
	ln -sfn $(GIT_DIR)/cinnamon $(HOME)/.config/cinnamon
	ln -sfn $(GIT_DIR)/.vimrc $(HOME)/.vimrc
	ln -sfn $(GIT_DIR)/.bashrc $(HOME)/.bashrc
	mkdir -p $(HOME)/.config/helix
	ln -sfn $(GIT_DIR)/helix-config.toml $(HOME)/.config/helix/config.toml
	@echo "Linking NixOS configuration to /etc/nixos..."
	sudo ln -sfn $(GIT_DIR)/nixos /etc/nixos
	@echo "All symlinks created successfully."

.PHONY: all link

