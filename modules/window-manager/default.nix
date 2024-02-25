{ config, pkgs, ... }: {

  services = {
    xserver = {
      enable = true;
      layout = "us";
      xkbVariant = "";

      # displayManager.gdm.enable = true;
      # desktopManager.gnome.enable = true;

      ## DWM
    windowManager.dwm.enable = true;
      displayManager = {
        lightdm.enable = true;
        defaultSession = "none+dwm";
        setupCommands = ''
          ${pkgs.xorg.xrandr}/bin/xrandr --output DP-1 --off --output DP-2 --off --output DP-3 --off --output HDMI-1 --mode 1920x1080 --pos 0x0 --rotate normal
        '';
        autoLogin = {
          enable = true;
          user = "arcana";
        };
      };
    };
  };

  nixpkgs.overlays = [
    (final: prev: {
      dwm = prev.dwm.overrideAttrs (old: {src = /home/arcana/.config/dwm;}); #FIX ME: Update with path to your dwm folder
    })
  ];

  xdg.portal = {
    enable = true;
    config.common.default = "*";
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
  };
}