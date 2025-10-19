{
  config,
  pkgs,
  lib,
  localUser,
  ...
}: {
  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 3;
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking
  networking.hostName = "${localUser}"; # Override via flake if desired
  networking.networkmanager.enable = true;

  # Time and locale
  time.timeZone = "Europe/London";
  i18n.defaultLocale = "en_GB.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };

  # X11 and Desktop
  services.xserver.enable = true;
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.desktopManager.cinnamon.enable = true;
  services.xserver.xkb = {
    layout = "gb";
    variant = "";
  };
  console.keyMap = "uk";

  # Printing and audio
  services.printing.enable = true;
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Users
  # NOTE: user 'tgval' must already exist on install; passwords are preserved
  users.users.${localUser} = {
    isNormalUser = true;
    description = "tgval";
    extraGroups = ["networkmanager" "wheel" "docker"];
  };

  # Docker
  virtualisation.docker.rootless.enable = true;
  virtualisation.docker.rootless.setSocketVariable = true;
  virtualisation.docker.daemon.settings = {
    data-root = "/home/${localUser}/docker";
    usarland-proxy = false;
  };

  # System packages
  environment.systemPackages = with pkgs; [
    vim
    wget
    curl
  ];

  # Firewall
  networking.firewall.checkReversePath = false;

  # Nix settings
  nix.settings.experimental-features = ["nix-command" "flakes"];
  nix.gc.automatic = true;
  nixpkgs.config.allowUnfree = true;

  # System state version
  system.stateVersion = "25.05";
}
