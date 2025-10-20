# NixOS Multi-Machine Configuration

This repository contains a flake-based NixOS configuration for multiple machines. It includes:

- Hardware-specific modules
- Home Manager configuration
- System-wide packages
- Makefile workflow for linking NixOS configuration and user dotfiles

Passwords are preserved on rebuilds.

---

## Repository Structure

- `Makefile` — helper for symlinking NixOS and user config  
- `flake.nix` — main flake configuration  
- `configuration.nix` — common system-wide configuration  
- `home.nix` — common Home Manager configuration  
- `machines/<machine>/hardware-configuration.nix` — hardware-specific modules  

Example tree:

```
nixos-config/
├── Makefile
├── flake.nix
├── configuration.nix
├── home.nix
└── machines/
    ├── tuxedo/
    │   └── hardware-configuration.nix
    ├── x1nano/
    │   └── hardware-configuration.nix
    └── legion/
        └── hardware-configuration.nix
```

---

## Initial Setup for a New Machine

1. **Install NixOS from USB**  
   - Set up partitions, swap, and install NixOS  
   - Create the initial user manually  
     - Username: match the machine config name (e.g., `tgval-tuxedo`)  
     - Password: choose a strong password

2. **Deploy the NixOS configuration**
   - Ensure `git and `gnumake` are installed on the initial installation
   - Backup the generated hardware-configuration.nix (or regenerate one with nixos-generate-config)
   - Copy the backed/generated `hardware-configuration.nix` to the correct subfolder on `nixos/machines`:
   - Delete the original /etc/nixos folder
   - Run `make link-nixos`

```bash
mkdir -p ~/nixos-config/machines/<machine-name>
cp /etc/nixos/hardware-configuration.nix ~/nixos-config/machines/<machine-name>/
```

3. **Rebuild the flake**  

```bash
cd ~/nixos-config
sudo nixos-rebuild switch --flake .#<machine-name>
```

- Applies hardware modules, Home Manager, and system packages  
- Default configs for apps are installed

Reboot afterwards

4. **Apply user dotfiles**  

This assumes Cinnamon as the desktop environment, backup the original configuration on ~/.config/cinnamon or delete it straight away.
```bash
make link-user
```

- Deploys customized dotfiles for Cinnamon, Helix, etc.

Reboot for the cinnamon config to be applied

---

## Makefile Targets

- `make link-nixos` — links `/etc/nixos` to the repo `nixos` folder  
- `make link-user` — links user dotfiles  
- `make all` — runs `link-nixos` first, then `link-user`

---

## Adding a New Machine

1. Create `machines/<new-machine>/hardware-configuration.nix`  
2. Add a new entry in `flake.nix` referencing the hardware module  
3. Use the existing `commonHomeModule` for Home Manager  
4. Do **not** define the user — the installation user is preserved  

---

## Notes

- User passwords are **never stored in Git**  
- Home Manager users must match the installation username  
- Tuxedo laptops include extra drivers and Tuxedo Control Center  
- Git and SSH keys can be configured independently

---

## Recommended Workflow

1. Install NixOS and create your username/password  
2. Deploy the `nixos` folder and copy `hardware-configuration.nix` to `machines/<machine-name>/`  
3. Rebuild the flake for your machine  
4. Run `make link-user` to apply dotfiles  
5. Modify configs as needed and rebuild — passwords remain intact

---

## References

- [NixOS Manual](https://nixos.org/manual/nixos/stable/)  
- [Home Manager](https://nix-community.github.io/home-manager/)  
- [NixOS Hardware Modules](https://github.com/NixOS/nixos-hardware)
