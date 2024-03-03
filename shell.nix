{pkgs, ...}: {

  default = pkgs.mkShell {
    NIX_CONFIG = "extra-experimental-features = nix-command flakes repl-flake";

    packages = [
      pkgs.statix
      pkgs.deadnix
      pkgs.alejandra
      pkgs.home-manager
      pkgs.git
      pkgs.sops
      pkgs.ssh-to-age
      pkgs.gnupg
      pkgs.age
    ];
  };
}
