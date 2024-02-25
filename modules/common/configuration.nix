{ config, pkgs, ... }: {

    documentation.nixos.enable = false;

    nix = {
        settings = {
            experimental-features = ["nix-command" "flakes"];
            auto-optimise-store = true;
            substituters = ["https://nix-gaming.cachix.org"];
            trusted-public-keys = ["nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="];
        };
    };

    nixpkgs = {
        config = {
        allowUnfree = true;
        allowUnfreePredicate = pkg: builtins.elem (builtins.parseDrvName pkg.name).name ["steam"];

        permittedInsecurePackages = [
            "openssl-1.1.1v"
            "python-2.7.18.7"
        ];
        };
    };    

    console = {
        packages = [pkgs.terminus_font];
        font = "${pkgs.terminus_font}/share/consolefonts/ter-i22b.psf.gz";
        useXkbConfig = true;
    };

    # Bootloader.
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
        timeout = 10;
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

    # Some programs need SUID wrappers, can be configured further or are
    # started in user sessions.
    programs.mtr.enable = true;
    programs.gnupg.agent = {
        enable = true;
        enableSSHSupport = true;
    };

    services = {
        flatpak.enable = true;
        dbus.enable = true;
        picom.enable = true;
        openssh.enable = true;
        printing.enable = true;
        # xserver.libinput.enable = true; # Enable touchpad support (enabled default in most desktopManager).
    };

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

    # Enable networking
    networking.networkmanager.enable = true;

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

      security.polkit.enable = true;

    systemd = {
        user.services.polkit-gnome-authentication-agent-1 = {
        description = "polkit-gnome-authentication-agent-1";
        wantedBy = ["graphical-session.target"];
        wants = ["graphical-session.target"];
        after = ["graphical-session.target"];
        serviceConfig = {
            Type = "simple";
            ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
            Restart = "on-failure";
            RestartSec = 1;
            TimeoutStopSec = 10;
        };
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