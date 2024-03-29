{ inputs, pkgs, lib, config, ... } : {
  imports = [
    ../../home-manager
    # ../../home-manager/programs/gaming.nix
    # ../../home-manager/programs/discord
  ];

  config = {
    modules = {
      browsers = {
        firefox.enable = true;
      };

      multiplexers = {
        zellij.enable = true;
      };

      shells = {
        fish.enable = true;
      };

      wms = {
        hyprland.enable = true;
      };

      terminals = {
        wezterm.enable = true;
      };
    };

    my.settings = {
      wallpaper = "~/dotfiles/home-manager/wallpapers/Kurzgesagt-Galaxy_3.png";
      host = "nix-tc";
      default = {
        shell = "${pkgs.fish}/bin/fish";
        terminal = "wezterm";
        browser = "firefox";
        editor = "code";
      };
    };

    colorscheme = inputs.nix-colors.colorSchemes.catppuccin-mocha;

    home = {
      username = lib.mkDefault "arcana";
      homeDirectory = lib.mkDefault "/home/${config.home.username}";
      stateVersion = lib.mkDefault "23.11";
    };
  };
}
