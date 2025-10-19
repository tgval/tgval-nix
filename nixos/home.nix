{
  pkgs,
  firefox-addons-allowUnfree,
  ...
}: {

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    gh
    gh-notify
    gh-contribs
    # archives
    zip
    xz
    unzip
    p7zip

    # utils
    ripgrep # recursively searches directories for a regex pattern
    jq # A lightweight and flexible command-line JSON processor
    yq-go # yaml processor https://github.com/mikefarah/yq
    eza # A modern replacement for ‘ls’
    fzf # A command-line fuzzy finder

    # networking tools
    mtr # A network diagnostic tool
    iperf3
    dnsutils # `dig` + `nslookup`
    ldns # replacement of `dig`, it provide the command `drill`
    aria2 # A lightweight multi-protocol & multi-source command-line download utility
    socat # replacement of openbsd-netcat
    nmap # A utility for network discovery and security auditing
    ipcalc # it is a calculator for the IPv4/v6 addresses

    # misc
    cowsay
    file
    which
    tree
    gnused
    gnutar
    gawk
    zstd
    gnupg

    # nix related
    #
    # it provides the command `nom` works just like `nix`
    # with more details log output
    nix-output-monitor

    btop # replacement of htop/nmon
    iotop # io monitoring
    iftop # network monitoring

    # system call monitoring
    strace # system call monitoring
    ltrace # library call monitoring
    lsof # list open files

    # system tools
    sysstat
    lm_sensors # for `sensors` command
    ethtool
    pciutils # lspci
    usbutils # lsusb

    #The stuff I had originally on configuration.nix
    thunderbird
    vscode
    helix
    helix-gpt
    conan
    cmake
    terminator
    git
    qgit
    docker
    sqlite
    python3Full
    poetry
    plantuml
    plantuml-server
    wineWowPackages.yabridge
    yabridge
    yabridgectl
    reaper
    drive
    rsync
    mullvad
    protonvpn-gui
    x11docker
    xorg.xhost
    dive
    rclone
    nixfmt-rfc-style
    clang
    libgcc
    gemini-cli
    nextcloud-client
    gnumake
  ];

  # basic configuration of git, please change to your own
  programs.git = {
    enable = true;
    userName = "tgval";
    userEmail = "tiago.valentim@protonmail.com";
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;
    # TODO add your custom bashrc here
    bashrcExtra = ''
      export PATH="$PATH:$HOME/bin:$HOME/.local/bin:$HOME/go/bin"
    '';

    # set some aliases, feel free to add more or remove some
    #shellAliases = {
    #};
  };

  programs.firefox = {
    enable = true;
    profiles.tgval = {
      search.engines = {
        "Nix Packages" = {
          urls = [
            {
              template = "https://search.nixos.org/packages";
              params = [
                {
                  name = "type";
                  value = "packages";
                }
                {
                  name = "query";
                  value = "{searchTerms}";
                }
              ];
            }
          ];

          icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          definedAliases = ["@np"];
        };
      };
      search.force = true;

      bookmarks = {
        force = true;
        settings = [
          {
            name = "wikipedia";
            tags = ["wiki"];
            keyword = "wiki";
            url = "https://en.wikipedia.org/wiki/Special:Search?search=%s&go=Go";
          }
        ];
      };

      settings = {
        "dom.security.https_only_mode" = true;
        "browser.download.panel.shown" = true;
        "browser.download.useDownloadDir" = false;
        "identity.fxaccounts.enabled" = false;
        "signon.rememberSignons" = false;
        "extensions.autoDisableScopes" = 0;
        "extensions.update.autoUpdateDefault" = false;
        "extensions.update.enabled" = false;
      };

      extensions.packages = with firefox-addons-allowUnfree; [
        bitwarden
        ublock-origin
        sponsorblock
        darkreader
        youtube-recommended-videos
        duckduckgo-privacy-essentials
        leechblock-ng
        old-reddit-redirect
        windscribe
        screenshot-capture-annotate
      ];
    };
  };

  programs.vscode = {
    enable = true;

    profiles.default = {
      userSettings = {
        # This property will be used to generate settings.json:
        # https://code.visualstudio.com/docs/getstarted/settings#_settingsjson
        "editor.formatOnSave" = false;
      };
      keybindings = [
        # See https://code.visualstudio.com/docs/getstarted/keybindings#_advanced-customization
        {
          key = "shift+cmd+j";
          command = "workbench.action.focusActiveEditorGroup";
          when = "terminalFocus";
        }
      ];

      # Some extensions require you to reload vscode, but unlike installing
      # from the marketplace, no one will tell you that. So after running
      # `darwin-rebuild switch`, make sure to restart vscode!
      extensions = with pkgs.vscode-marketplace; [
        # Search for vscode-extensions on https://search.nixos.org/packages
        ms-vscode-remote.remote-ssh
        ms-vscode.makefile-tools
        ms-vsliveshare.vsliveshare
        ms-python.python
        ms-vscode.cmake-tools
        charliermarsh.ruff
        jebbs.plantuml
        ms-azuretools.vscode-docker
        ms-vscode-remote.remote-containers
        redhat.vscode-yaml
        ms-vscode.cpptools-extension-pack
        llvm-vs-code-extensions.vscode-clangd
        xaver.clang-format
        kamadorueda.alejandra
        rust-lang.rust-analyzer
        ms-dotnettools.csharp
        golang.go
      ];
    };
  };
  # This value determines the home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "25.05";
}
