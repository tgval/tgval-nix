# tgval-nix
My NixOS + dotfiles setup

--flake .#tgval-legion - Old Lenovo Legion compatible config
--flake .#tgval-x1nano - Lenovo Thinkpad X1 Nano config
--flake .#tgval-tuxedo - Tuxedo Infinity Book Pro 15 config

.bashrc / .vimrc / cinnamon desktop environment / helix editor configs

`make` sets up the symbolic links based on the location of the repo + assuming .rc's go to ~ and cinnamon/helix go into ~/.config/cinnamon and ~/.config/helix/config.toml respectively.

By default, MACHINE=legion on the Makefile argument to select which hardware-configuration.nix to backup - options are "legion" "x1nano" "tuxedo" currently.
