{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nix-colors.url = "github:misterio77/nix-colors";
    hyprland.url = "github:hyprwm/Hyprland";

    home-manager = {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur = {
        url = "github:nix-community/NUR";
        inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, nur, hyprland,  ... }@inputs:
  let
    inherit (self) outputs;
    lib = nixpkgs.lib // home-manager.lib;
    systems = ["x86_64-linux" "aarch64-linux"];
    forEachSystem = f: lib.genAttrs systems (sys: f pkgsFor.${sys});
    pkgsFor = nixpkgs.legacyPackages;

    # This lets us reuse the code to "create" a system
    # Credits go to sioodmy on this one!
    # https://github.com/sioodmy/dotfiles/blob/main/flake.nix
    mkSystem = pkgs: system: hostname:
        pkgs.lib.nixosSystem {
            system = system;
            modules = [
                hyprland.nixosModules.default
                { networking.hostName = hostname; }
                # General configuration (users, networking, sound, etc)
                ./modules/system/configuration.nix
                # Hardware config (bootloader, kernel modules, filesystems, etc)
                # DO NOT USE MY HARDWARE CONFIG!! USE YOUR OWN!!
                (./. + "/hosts/${hostname}/hardware-configuration.nix")
                home-manager.nixosModules.home-manager
                {
                    home-manager = {
                        useUserPackages = true;
                        useGlobalPkgs = true;
                        extraSpecialArgs = { inherit inputs; };
                        # Home manager config (configures programs like firefox, zsh, eww, etc)
                        users.arcana = (./. + "/hosts/${hostname}/user.nix");
                    };
                    nixpkgs.overlays = [
                        # Add nur overlay for Firefox addons
                        nur.overlay
                        (import ./overlays)
                    ];
                }
            ];
            specialArgs = { inherit inputs; };
        };


  in{
    nixosConfigurations = {
        # Now, defining a new system is can be done in one line
        #                                Architecture   Hostname
        nixos = mkSystem inputs.nixpkgs "x86_64-linux" "nixos";
        #desktop = mkSystem inputs.nixpkgs "x86_64-linux" "desktop";

    };
  };
}