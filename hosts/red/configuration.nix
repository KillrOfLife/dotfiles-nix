  # Edit this configuration file to define what should be installed on
  # your system.  Help is available in the configuration.nix(5) man page
  # and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }: {
  imports = [ 
    ./hardware-configuration.nix
    ../../nixos
    ../../users
  ];

  modules.nixos = {
    docker.enable = false;
    login.enable = false; #hyrland greeter
    extraSecurity.enable = false;
    virtualisation.enable = false;
  };

  # Virtualisation
  # virtualisation.vmware.guest.enable = true;
  
  # Networking
  networking = {
    networkmanager.enable = true;
    enableIPv6 = false;
    
    firewall = {
      enable = true;
      allowedTCPPorts = [22];
      allowedUDPPorts = [22];
      allowPing = true;
    };

    # Configure network proxy if necessary
    # proxy = {
    #   default = "http://user:password@proxy:port/";
    #   noProxy = "127.0.0.1,localhost,internal.domain";
    # };
  };

  # Bootloader
  ## do not touch unless you know what you're doing
  boot = {
      kernelParams = ["nohibernate"];
      tmp.cleanOnBoot = true;
      supportedFilesystems = ["ntfs"];
      loader = {
        efi.canTouchEfiVariables = true;
        grub = {
            device = "nodev";
            efiSupport = true;
            enable = true;
            useOSProber = true;
            timeoutStyle = "menu";
        };
        timeout = 10; #grub timeout
      };

      kernelModules = ["tcp_bbr"];
      kernel.sysctl = {
      "net.ipv4.tcp_congestion_control" = "bbr";
      "net.core.default_qdisc" = "fq";
      "net.core.wmem_max" = 1073741824;
      "net.core.rmem_max" = 1073741824;
      "net.ipv4.tcp_rmem" = "4096 87380 1073741824";
      "net.ipv4.tcp_wmem" = "4096 87380 1073741824";
      };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
