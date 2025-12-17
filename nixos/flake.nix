{
  description = "NixOS multi-machine configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-master.url = "github:nixos/nixpkgs/master";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions/";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware = {
      url = "github:NixOS/nixos-hardware/master";
    };

    tuxedo-nixos = {
      url = "github:sund3RRR/tuxedo-nixos";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-master,
    home-manager,
    firefox-addons,
    nix-vscode-extensions,
    nixos-hardware,
    tuxedo-nixos,
    ...
  }: let
    system = "x86_64-linux";

    # Base packages
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
      overlays = [nix-vscode-extensions.overlays.default];
    };

    pkgs-master = import nixpkgs-master {
      inherit system;
      config.allowUnfree = true;
    };

    # Build firefox-addons once for all machines
    firefox-addons-allowUnfree = pkgs.callPackage firefox-addons {};

    # Function to create a nixosSystem per machine
    mkMachine = {
      username,
      hwModule,
      extraModules ? [],
    }:
      nixpkgs.lib.nixosSystem {
        inherit system;
        modules =
          [
            ./configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.${username} = import ./home.nix {
                inherit pkgs firefox-addons-allowUnfree;
              };
            }
            hwModule
          ]
          ++ extraModules;
        specialArgs = { localUser = username;};
      };
  in {
    nixosConfigurations = {
      # Tuxedo Laptop
      tgval-tuxedo = mkMachine {
        username = "tgval-tuxedo";
        hwModule = ./machines/tuxedo/hardware-configuration.nix;
        extraModules = [
          nixos-hardware.nixosModules.tuxedo-infinitybook-pro14-gen9-amd

          # Tuxedo drivers overlay from nixpkgs-master
          ({...}: {
            nixpkgs.overlays = [
              (final: prev: {
                tuxedo-drivers =
                  pkgs-master.callPackage
                  (pkgs-master + "/pkgs/os-specific/linux/tuxedo-drivers") {};
              })
            ];
          })

          # Tuxedo Control Center
          tuxedo-nixos.nixosModules.default
        ];
      };

      # Lenovo ThinkPad X1 Nano Gen1
      tgval-x1nano = mkMachine {
        username = "tgval-x1nano";
        hwModule = ./machines/x1nano/hardware-configuration.nix;
        extraModules = [nixos-hardware.nixosModules.lenovo-thinkpad-x1-nano-gen1];
      };

      # Lenovo Legion
      tgval-legion = mkMachine {
        username = "tgval";
        hwModule = ./machines/legion/hardware-configuration.nix;
        extraModules = [];
      };
    };
  };
}
