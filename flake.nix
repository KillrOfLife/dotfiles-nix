{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... } @inputs: 
    let
      user = "arcana";

      inherit (self) outputs;
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
                  # General configuration (users, networking, sound, etc)
                  (./. + "/hosts/${hostname}/configuration.nix")
                  # Hardware config (bootloader, kernel modules, filesystems, etc)
                  # DO NOT USE MY HARDWARE CONFIG!! USE YOUR OWN!!
                  (./. + "/hosts/${hostname}/hardware-configuration.nix")
                  home-manager.nixosModules.home-manager
                  {
                      home-manager = {
                          useUserPackages = true;
                          useGlobalPkgs = true;
                          extraSpecialArgs = { inherit inputs self user; };
                          # Home manager config (configures programs like firefox, zsh, eww, etc)
                          users.arcana = (./. + "/hosts/${hostname}/user.nix");
                      };
                  }
              ];
              specialArgs = { inherit inputs; };
          };

    in {
       nixosConfigurations = {
        # Now, defining a new system is can be done in one line
        #                                Architecture   Hostname
        nixos = mkSystem inputs.nixpkgs "x86_64-linux" "nixos";
        desktop = mkSystem inputs.nixpkgs "x86_64-linux" "desktop";
        VM = mkSystem inputs.nixpkgs "x86_64-linux" "VM";
    };
  };
}
