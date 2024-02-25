{pkgs, ...}: let
  user = "arcana";
in {
  imports = [
    ../../packages
  ];

  fonts.fontconfig.enable = true;

  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
    };
  };

  home = {
    username = "${user}";
    homeDirectory = "/home/${user}";
    stateVersion = "23.11";

    #list the packages specific to your user
    packages = with pkgs; [
      w3m
      dmenu
      neofetch
      neovim
      starship
      bat
      bazecor
      cargo
      celluloid
      chatterino2
      clang-tools_9
      dunst
      docker-compose
      efibootmgr
      elinks
      eww
      feh
      firefox
      flameshot
      flatpak
      floorp
      fontconfig
      freetype
      fuse-common
      gcc
      gimp
      git
      github-desktop
      gnome.gnome-keyring
      gnugrep
      gnumake
      gparted
      gnugrep
      grub2
      hugo
      kitty
      libverto
      luarocks
      lxappearance
      mangohud
      neovim
      nfs-utils
      ninja
      nodejs
      nomacs
      openssl
      os-prober
      nerdfonts
      pavucontrol
      picom
      polkit_gnome
      powershell
      protonup-ng
      python3Full
      python.pkgs.pip
      qemu
      ripgrep
      rofi
      steam
      steam-run
      sxhkd
      st
      stdenv
      synergy
      swaycons
      terminus-nerdfont
      tldr
      trash-cli
      unzip
      variety
      virt-manager
      xclip
      xdg-desktop-portal-gtk
      xfce.thunar
      xorg.libX11
      xorg.libX11.dev
      xorg.libxcb
      xorg.libXft
      xorg.libXinerama
      xorg.xinit
      xorg.xinput
      zoxide
      (lutris.override {
        extraPkgs = pkgs: [
          # List package dependencies here
          wineWowPackages.stable
          winetricks
        ];
      })
    ];
  };
}
