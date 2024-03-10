{pkgs ? (import ../nixpkgs.nix) {}}: {
  monolisa = pkgs.callPackage ./monolisa {};
  adwaita-for-steam = pkgs.callPackage ./adwaita-for-steam {};
}
