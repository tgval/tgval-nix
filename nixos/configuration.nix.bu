# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 3;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "tgval"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/London";

  # Select internationalisation properties.
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

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the XFCE Desktop Environment.
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.desktopManager.cinnamon.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "gb";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "uk";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.tgval = {
    isNormalUser = true;
    description = "tgval";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
    ];
  };

  # docker setup
  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };
  virtualisation.docker.daemon.settings = {
    data-root = "/home/tgval/docker";
    usarland-proxy = false;
  };

  # Install firefox.
  programs.firefox.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    (vim_configurable.customize {
      name = "vim";
      vimrcConfig.customRC = ''
        	set mouse-=a
      '';
    })
    wget
    curl
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Allow local webservers on port 80

  # Open ports in the firewall.
  #networking.firewall.allowedTCPPorts = [6080 6081 ];
  #networking.firewall.allowedUDPPorts = [6080 6081 ];
  networking.firewall = {
    extraCommands = ''
      iptables -N BASIC_SETUP
      iptables -A INPUT -j BASIC_SETUP
      iptables -A BASIC_SETUP -m comment -s 127.0.0.1 -m state --state NEW -m tcp -p tcp --dport 5900 -j ACCEPT --comment "VNC defaults"
      iptables -A BASIC_SETUP -m comment -s 127.0.0.1 -m state --state NEW -m udp -p udp --dport 5900 -j ACCEPT --comment "VNC defaults"
      iptables -A BASIC_SETUP -m comment -s 127.0.0.1 -m state --state NEW -m tcp -p tcp --dport 80 -j ACCEPT --comment "Default for webservers"
      iptables -A BASIC_SETUP -m comment -s 127.0.0.1 -m state --state NEW -m udp -p udp --dport 80 -j ACCEPT --comment "Default for webservers"
    '';
    #flush the chain then remove it
    extraStopCommands = ''
      iptables -D INPUT -j BASIC_SETUP
      iptables -F BASIC_SETUP
      iptables -X BASIC_SETUP
    '';
  };
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
  # Set this so ProtonVPN has Internet connection
  networking.firewall.checkReversePath = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nix.gc.automatic = true;
  nixpkgs.config.allowUnfree = true;
}
