{
  description = "NixOS configuration with machine-specific hardware modules and Home Manager";

  inputs = {
    # Stable base (NixOS 25.05)
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";

    # Home Manager (same branch as NixOS)
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Firefox Addons
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # VSCode Extensions overlay
    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Master sources (unpinned by default — locked via flake.lock)
    nixpkgs-master.url = "github:NixOS/nixpkgs/master";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    tuxedo-nixos.url = "github:sund3RRR/tuxedo-nixos/master";
  };

  outputs = inputs @ {
    nixpkgs,
    nixpkgs-master,
    nixos-hardware,
    tuxedo-nixos,
    home-manager,
    firefox-addons,
    nix-vscode-extensions,
    ...
  }: let
    system = "x86_64-linux";
    username = "tgval";

    # Import nixpkgs-master separately for tuxedo-drivers
    pkgs-master = import nixpkgs-master {inherit system;};

    # Overlay: pull tuxedo-drivers from nixpkgs-master
    tuxedoDriverOverlay = final: prev: {
      tuxedo-drivers = pkgs-master.tuxedo-drivers;
    };

    # Stable pkgs for all systems
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
      overlays = [nix-vscode-extensions.overlays.default];
    };

    # Shared Home Manager setup
    commonHomeModule = {pkgs}: {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.${username} = import ./home.nix;
      home-manager.extraSpecialArgs = {
        inherit inputs pkgs;
        firefox-addons-allowUnfree = pkgs.callPackage firefox-addons {};
      };
      home-manager.backupFileExtension = "bu";
    };
  in {
    nixosConfigurations = {
      # 🖥️ Tuxedo laptop (master tuxedo-drivers + tuxedo-control-center)
      tgval-tuxedo = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./configuration.nix
          nixos-hardware.nixosModules.tuxedo
          tuxedo-nixos.nixosModules.tuxedo-control-center
          home-manager.nixosModules.home-manager
          (commonHomeModule {inherit pkgs;})
        ];
        # Add overlay only for tuxedo
        nixpkgs.overlays = [tuxedoDriverOverlay];
      };

      # 💻 Lenovo ThinkPad X1 Nano
      tgval-x1nano = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./configuration.nix
          nixos-hardware.nixosModules.lenovo-thinkpad-x1-nano
          home-manager.nixosModules.home-manager
          (commonHomeModule {inherit pkgs;})
        ];
      };

      # 🎮 Lenovo Legion (no special hardware module)
      tgval-legion = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./configuration.nix
          home-manager.nixosModules.home-manager
          (commonHomeModule {inherit pkgs;})
        ];
      };
    };
  };
}
