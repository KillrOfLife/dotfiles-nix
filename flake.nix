{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    hyprland.url = "github:hyprwm/Hyprland";
    nur.url = "github:nix-community/NUR";
    nixgl.url = "github:nix-community/nixGL";
    nix-colors.url = "github:misterio77/nix-colors";
    sops-nix.url = "github:mic92/sops-nix";
    nix-flatpak.url = "github:gmodena/nix-flatpak";

    zjstatus.url = "github:dj95/zjstatus";
    hypr-contrib.url = "github:hyprwm/contrib";
    hyprland-nix.url = "github:spikespaz/hyprland-nix";

    nwg-displays.url = "github:nwg-piotr/nwg-displays";
    comma.url = "github:nix-community/comma";
    nix-gaming.url = "github:fufexan/nix-gaming";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };


    firefox-gnome-theme = {
      url = "github:rafaelmardojai/firefox-gnome-theme";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, home-manager, hyprland, nix-flatpak, ... } @inputs: let
    inherit (self) outputs;
    lib = nixpkgs.lib // home-manager.lib;
    systems = ["x86_64-linux" "aarch64-linux"];
    forEachSystem = f: nixpkgs.lib.genAttrs systems (sys: f pkgsFor.${sys});
    pkgsFor = nixpkgs.legacyPackages;

    # This lets us reuse the code to "create" a system
    # Credits go to sioodmy on this one!
    # https://github.com/sioodmy/dotfiles/blob/main/flake.nix
    mkSystem = pkgs: system: hostname:
      nixpkgs.lib.nixosSystem {
          system = system;
          modules = [
              hyprland.nixosModules.default
              nix-flatpak.nixosModules.nix-flatpak

              { networking.hostName = hostname; }
              (./. + "/hosts/${hostname}/configuration.nix")
          ];
          specialArgs = { inherit inputs outputs; };
      };

  in {
    nixosModules = import ./modules/nixos;
    homeManagerModules = import ./modules/home-manager;
    overlays = import ./overlays {inherit inputs outputs;};
    packages = forEachSystem (pkgs: import ./pkgs {inherit pkgs;});
    devShells = forEachSystem (pkgs: import ./shell.nix {inherit pkgs inputs;});

    nixosConfigurations = {
    # Now, defining a new system is can be done in one line
    #                                Architecture   Hostname
    test-vm = mkSystem inputs.nixpkgs "x86_64-linux" "test-vm";
    nix-tc = mkSystem inputs.nixpkgs "x86_64-linux" "nix-tc" ;

    # nixos = mkSystem inputs.nixpkgs "x86_64-linux" "nixos";
    # desktop = mkSystem inputs.nixpkgs "x86_64-linux" "desktop";
    # VM = mkSystem inputs.nixpkgs "x86_64-linux" "VM";

    # Used in creating a custom ISO
    # iso = lib.nixosSystem{
    #     modules = [
    #         "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-graphical-gnome.nix"
    #         "${nixpkgs}/nixos/modules/installer/cd-dvd/channel.nix"
    #         ./hosts/iso/configuration.nix
    #     ];
    #     specialArgs = { inherit inputs outputs; };
    # };
    };
    homeConfigurations = {
      nix-tc = lib.homeManagerConfiguration {
        modules = [./hosts/nix-tc/home.nix];
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = {inherit inputs outputs;};
      };
    };

  };
}
