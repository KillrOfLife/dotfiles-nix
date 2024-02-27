  # Edit this configuration file to define what should be installed on
  # your system.  Help is available in the configuration.nix(5) man page
  # and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }: {
  imports = [ 
    ./hardware-configuration.nix
  ];

programs.hyprland = {
	enable = true;
	xwayland.enable = true;
};

environment.sessionVariables = {
	WLR_NO_HARDWARE_CURSORS = "1";

	NIXOS_OZONE_WL = "1";

};



hardware = {
	opengl.enable = true;
	nvidia.modesetting.enable = true;


};

xdg = {
	portal ={
		enable = true;
		extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
};
};




  # Set your time zone.
  time.timeZone = "Europe/Brussels";
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
      packages = [pkgs.terminus_font];
      font = "${pkgs.terminus_font}/share/consolefonts/ter-i22b.psf.gz";
      useXkbConfig = true;
  };

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
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDpTwXq8dZpn5dI/eNEXyqDREautKqjBXXGCs/yrLLp2bE9y7cH64HNUNUb+Eu9kdYDXui3DZsK1o+Rjg5sr0+qBm/tu2l9fS0/+3uQu+Dx6+pms4pGKUQ8CVlAxeDO0U/UO3ZirN2buzqWtKr6n8YvhaVxm3i75M0iDFW40vWYv+uU/bOOlOq9E6G3SM5dGqVT4Haz4CPXM5qSfTh6cf1gAoE72zNbU/Gtr08+If4zquQHHvvmuGB4U0671Ktirmfu5v9if+cqzDka6ayZinzci0ekY7LIg2B7x1RHP4d2eNQrxH3x65IvdQShMa3fZtIr8UER7xkHlLMljWlL4rwCzFVwGWJPoDkVYK3P009yDzIz1t1D5+9WvX9/iYqmgfmHaZAPtMbHcO/QonR9lXAMyLJ6FbyT9+TvyANO00PhYG9U9f9RzU0UlNdgiBED9/uxKl9Yv2XpyERYLocwwVdRtJdL889NT9fcbmRtsVzYoW0IMVloEJ5Vl29T7GXM+Cs= hpcds\50052560@AutoPCfm37QDt2r"

    ];
  };

  # Globaly enabled programs  
#  programs.zsh.enable = true;
  programs.mtr.enable = true;
  programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
  };

  environment.systemPackages = with pkgs; [
      acpi tlp git wget vim 
	waybar dunst swww kitty rofi-wayland # for hyprland

	#(waybar.overrideAttrs (oldAttrs: {
#		mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
#	})
#	)
  ];
  # Install fonts
  fonts = {
      packages = with pkgs; [
          noto-fonts
          noto-fonts-cjk
          noto-fonts-emoji
          font-awesome
          source-han-sans
          source-han-sans-japanese
          source-han-serif-japanese
          (nerdfonts.override {fonts = ["Meslo"];})
      ];
      fontconfig = {
          enable = true;
          defaultFonts = {
              monospace = ["Meslo LG M Regular Nerd Font Complete Mono"];
              serif = ["Noto Serif" "Source Han Serif"];
              sansSerif = ["Noto Sans" "Source Han Sans"];
          };
      };
  };

  # Nix settings, auto cleanup and enable flakes
  documentation.nixos.enable = false;
  nix = {
      settings = {
          warn-dirty = false;
          experimental-features = ["nix-command" "flakes"];
          auto-optimise-store = true;
          substituters = ["https://nix-gaming.cachix.org"
		"https://hyprland.cachix.org"];
          trusted-public-keys = [
		"nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
		"hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
];
          
      };
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 7d";
      };
  };

  nixpkgs = {
      config = {
      allowUnfree = true;
      # allowUnfreePredicate = pkg: builtins.elem (builtins.parseDrvName pkg.name).name ["steam"];

      # permittedInsecurePackages = [
      #     "openssl-1.1.1v"
      #     "python-2.7.18.7"
      # ];
      };
  };    

  # Services
  services = {
      # flatpak.enable = true;
      # dbus.enable = true;
      # picom.enable = true;

      openssh = {
          enable = true;
          settings = {
              X11Forwarding = true;
          };
      };
      printing.enable = false;
  };

  # Virtualisation
  virtualisation.docker.enable = true;
 # virtualisation.vmware.guest.enable = true;
  
  # Networking
  networking = {
    networkmanager.enable = true;
    enableIPv6 = false;
    
    firewall = {
      enable = true;
      allowedTCPPorts = [22 80 443];
      allowedUDPPorts = [22 80 443];
      allowPing = true;
    };

    # Configure network proxy if necessary
    # proxy = {
    #   default = "http://user:password@proxy:port/";
    #   noProxy = "127.0.0.1,localhost,internal.domain";
    # };
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
