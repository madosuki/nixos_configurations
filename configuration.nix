# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  # boot.loader.systemd-boot.enable = true;

  boot.loader = {
    efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi";
    };
    grub = {
        enable = true;
        efiSupport = true;
        device = "nodev";
    };
  };
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = [ 
    "kvm.enable_virt_at_load=0"
    # "amd_iommu"
  ];
  # kvm_amd is only using with AMD CPU. When intel cpu, replace kvm_intel.
  # boot.extraModprobeConfig = "options kvm_amd nested=1";
  # boot.extraModprobeConfig = "options kvm.enable_virt_at_load=0";

  services.udisks2.enable = true;

  # networking.hostName = "nixos"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Asia/Tokyo";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  networking.firewall = {
      enable = true;
  };

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    # font = "Lat2-Terminus16";
    # keyMap = "us";
    useXkbConfig = true; # use xkb.options in tty.
  };
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.addons = with pkgs; [
        fcitx5-mozc
        fcitx5-hangul
        fcitx5-rime
        fcitx5-gtk
    ];
    fcitx5.waylandFrontend = true;
  };

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-color-emoji
    font-awesome
    hackgen-font
  ];

  # Enable the X11 windowing system.
  services.xserver.enable = true;


  # Enable the GNOME Desktop Environment.
  # services.xserver.displayManager.gdm.enable = true;
  # services.xserver.desktopManager.gnome.enable = true;
  services.displayManager.sddm = {
    enable = true;
     extraPackages = with pkgs; [
        sddm-astronaut
              kdePackages.qtbase
              kdePackages.qtwayland
              kdePackages.qtmultimedia
    ];
    theme = "sddm-astronaut-theme";
    settings = {
        Theme = {
            Current = "sddm-astronaut-theme";
        };
    };
  };
  

  # Configure keymap in X11
  services.xserver.xkb.layout = "us";
  services.xserver.xkb.options = "ctrl:nocaps";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # services.pulseaudio.enable = true;
  # OR
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  services.power-profiles-daemon.enable = true;

  services.gvfs.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.user = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "audio" "libvirtd" "docker" "vboxusers" "kvm" "adbusers" "input" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      tree
      steghide
      gobuster
    ];
  };

  programs.chromium.enable = true;
  programs.firefox.enable = true;
  programs.hyprland.enable = true;
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
  };
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;
  programs.virt-manager.enable = true;
  users.groups.libvirtd.members = [ "user" ];
  virtualisation.libvirtd.enable = true;
  virtualisation.libvirtd.qemu = {
    swtpm.enable = true;
  };
  virtualisation.spiceUSBRedirection.enable = true;
  virtualisation.docker = {
      enable = true;
  };
  virtualisation.virtualbox.host.enable = true;

  # programs.adb.enable = true;

  security.polkit.enable = true;
  services.flatpak.enable = true;
  xdg.portal = {
    enable = true;
  };
  xdg.menus.enable = true;
  xdg.mime.enable = true;

  services.gnome.gnome-keyring.enable = true;

  security.apparmor.packages = with pkgs; [ apparmor-profiles ];
  security.apparmor = {
    enable = true;
    policies.firefox.path = "${pkgs.apparmor-profiles}/etc/apparmor.d/firefox";
        policies.thunderbird.path = "${pkgs.apparmor-profiles}/etc/apparmor.d/thunderbird";
        policies.flatpak.path = "${pkgs.apparmor-profiles}/etc/apparmor.d/flatpak";
  };

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc.lib
    zlib
    zstd
    curl
    openssl
    attr
    libssh
    bzip2
    libxml2
    acl
    libsodium
    util-linux
    xz
    systemd
    cairo
    mesa
  ];

  services.clamav.daemon.enable = true;
  services.clamav.updater.enable = true;

  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [ (import /home/user/Documents/my_overlay/overlay.nix)  ];

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    kitty 
    gh
    _7zz
    git
    keepassxc
    vlc
    neovim
    btrfs-progs
    fuzzel
    pavucontrol
    swaynotificationcenter
    waybar
    networkmanagerapplet
    hyprpaper
    hyprlock
    hypridle
    polkit_gnome
    kdePackages.ark
    kdePackages.kate
    kdePackages.gwenview
    pcmanfm
    adwaita-icon-theme
    (chromium.override {
    commandLineArgs = [
    # "--ozone-platform=x11"
    # "--force-device-scale=1"
    ];
    })
    tmux
    nix-ld
    appimage-run
    gnumake
    desktop-file-utils
    whois
    xsel
    wl-clipboard
    emacs-pgtk
    gimp
    inkscape
    vscodium
    clamav
    imagemagick
    fontconfig
    libarchive
    veracrypt
    pinentry-all
    apparmor-profiles
    apparmor-utils
    apparmor-parser
    (sddm-astronaut.override {
    embeddedTheme = "hyprland_kath";    
    themeConfig = {
        Background = "${builtins.path { path = /home/user/Pictures/wallpaper.png; name = "wallpaper"; }}";
    #    Font = "";
    };
    })
    evince
    zip
    unzip
    texliveFull
    thunderbird
    nil
    bind
    htop
    mpv
    # ghidra
    spotify
    psmisc
    steam-run
    android-file-transfer
    android-studio
    android-tools
    ((ffmpeg_8-full.override { withUnfree = true; withGPL = true; }).overrideAttrs (_: { doCheck = false; }))
    guile
    protonup-qt
    rhythmbox
    nix-prefetch-git
    multimarkdown
    gemini-cli
    gnome-disk-utility
    unityhub
    wireshark
    # jdim
  ];

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  systemd.user.services.polkit-gnome-authentication-agent-1 = {
    description = "polkit-gnome-authentication-agent-1";
    wantedBy = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
    };
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryPackage = pkgs.pinentry-all;
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.11"; # Did you read the comment?

}

