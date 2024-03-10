{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./theme.nix
    ./bottom.nix
    ./cheat-sheets.nix
    ./direnv.nix

    # ./docker.nix
    ./eza.nix
    ./fonts.nix
    ./fzf.nix
    ./git.nix
    ./modern-unix.nix
    ./kdeconnect.nix
    ./yazi.nix
    ./starship.nix
    # ./spotify.nix
    ./zoxide.nix
  ];

  home.packages = with pkgs; [
    powertop

    nix-your-shell

    (lib.hiPrio parallel)
    moreutils
    nvtop-intel
    htop
    unzip
    gnupg

    # showmethekey
  ];
}
