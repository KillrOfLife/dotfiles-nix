# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  # Remove unecessary preinstalled packages
  environment.defaultPackages = [ ];
  services.xserver.desktopManager.gnome.enable = false;
  services.xserver.desktopManager.xterm.enable = false;

  programs.zsh.enable = true;

  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    acpi tlp git wget
  ];

  # Install fonts
  fonts = {
      packages = with pkgs; [
          jetbrains-mono
          roboto
          openmoji-color
          (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
      ];

      fontconfig = {
          hinting.autohint = true;
          defaultFonts = {
            emoji = [ "OpenMoji Color" ];
          };
      };
  };

  # Wayland stuff: enable XDG integration, allow sway to use brillo
  xdg = {
      portal = {
          enable = true;
          extraPortals = with pkgs; [
              xdg-desktop-portal-wlr
              xdg-desktop-portal-gtk
          ];
      };
  };

  # Nix settings, auto cleanup and enable flakes
  nix = {
      settings.auto-optimise-store = true;
      settings.allowed-users = [ "arcana" ];
      gc = {
          automatic = true;
          dates = "weekly";
          options = "--delete-older-than 7d";
      };
      extraOptions = ''
          experimental-features = nix-command flakes
          keep-outputs = true
          keep-derivations = true
      '';
  };

  boot = {
    tmp.cleanOnBoot = true;
    loader = {
      systemd-boot.enable = true;
      systemd-boot.editor = false;
      efi.canTouchEfiVariables = true;
      timeout = 0;
    };
  };

  # Set locales
  time.timeZone = "Europe/Brussels";
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-erminus16";
    keyMap = "us";
  };

  # Set up user and enable sudo
  users.users.arcana = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
    packages = with pkgs; [
      firefox
      # warp-terminal
      #  thunderbird
    ];
    openssh.authorizedKeys.keys = [ 
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG5BRKIFhkbNDgELm/iTP8QHcanlsVNo+RlE3pRDRwDA arcana@Revision-PC-AMD"
    ]
  };

  networking = {
    # wireless.enable = true;  # Enables wireless support via wpa_supplicant.
    # networkmanager.enable = true;

    wireless.iwd.enable = true;
    firewall = {
      enable = true;
      allowedTCPPorts = [22 80 443];
      allowedUDPPorts = [22 80 443];
      allowPing = true;
    };
  };

  # Set environment variables
  environment.variables = {
    NIXOS_CONFIG = "$HOME/.config/nixos/configuration.nix";
    NIXOS_CONFIG_DIR = "$HOME/.config/nixos/";
    XDG_DATA_HOME = "$HOME/.local/share";
    PASSWORD_STORE_DIR = "$HOME/.local/share/password-store";
    GTK_RC_FILES = "$HOME/.local/share/gtk-1.0/gtkrc";
    GTK2_RC_FILES = "$HOME/.local/share/gtk-2.0/gtkrc";
    MOZ_ENABLE_WAYLAND = "1";
    ZK_NOTEBOOK_DIR = "$HOME/stuff/notes/";
    EDITOR = "nvim";
    DIRENV_LOG_FORMAT = "";
    ANKI_WAYLAND = "1";
    DISABLE_QT5_COMPAT = "0";
  };

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
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


  # Disable bluetooth, enable pulseaudio, enable opengl (for Wayland)
  hardware = {
      bluetooth.enable = false;
      opengl = {
          enable = true;
          driSupport = true;
      };
  };


  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";


  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget


  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
