  # Edit this configuration file to define what should be installed on
  # your system.  Help is available in the configuration.nix(5) man page
  # and in the NixOS manual (accessible by running ‘nixos-help’).

  { config, pkgs, ... }: {

    imports = [
      ./hardware-configuration.nix
      ../../modules/common/configuration.nix
      ../../modules/window-manager/default.nix
    ];



    # Set your time zone.
    time.timeZone = "Europe/Brussels";
    i18n.defaultLocale = "en_US.UTF-8";

    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.arcana = {
      isNormalUser = true;
      description = "arcana";
      extraGroups = [
        "networkmanager" 
        "wheel"
        "docker"
      ];
      openssh.authorizedKeys.keys = [ 
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG5BRKIFhkbNDgELm/iTP8QHcanlsVNo+RlE3pRDRwDA arcana@Revision-PC-AMD"
      ];
    };

    # List packages installed in system profile. To search, run:
    # $ nix search wget
    environment.systemPackages = with pkgs; [
      vim
      wget
    ];

    # Open ports in the firewall.
    networking = {
      networkmanager.enable = true;
      enableIPv6 = false;
      
      firewall.enable = false;
      # firewall.allowedTCPPorts = [ ... ];
      # firewall.allowedUDPPorts = [ ... ];

      # Configure network proxy if necessary
      # proxy = {
      #   default = "http://user:password@proxy:port/";
      #   noProxy = "127.0.0.1,localhost,internal.domain";
      # };
    };

    virtualisation.docker.enable = true;
  }
