{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko.url = "github:nix-community/disko";
    # sops-nix.url = "github:mic92/sops-nix";




  };

  outputs = { self, nixpkgs, home-manager, ... } @inputs: 
    let
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
                  { networking.hostName = hostname; }
                  (./. + "/hosts/${hostname}/configuration.nix")

                #   home-manager.nixosModules.home-manager
                #   {
                #       home-manager = {
                #           useUserPackages = true;
                #           useGlobalPkgs = true;
                #           extraSpecialArgs = { inherit inputs self user; };
                #           # Home manager config (configures programs like firefox, zsh, eww, etc)
                #           users.arcana = (./. + "/hosts/${hostname}/user.nix");
                #       };
                #   }
              ];
              specialArgs = { inherit inputs outputs; };
          };

    in {
       nixosConfigurations = {
        # Now, defining a new system is can be done in one line
        #                                Architecture   Hostname
        test-vm = mkSystem inputs.nixpkgs "x86_64-linux" "test-vm";

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
  };
}
