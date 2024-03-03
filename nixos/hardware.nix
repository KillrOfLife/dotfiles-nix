{pkgs, ...}: {
  services.printing.enable = true;
  hardware.enableAllFirmware = true;
  # hardware.keyboard.zsa.enable = true;
  # services.hardware.bolt.enable = true;
  # hardware.logitech.wireless.enable = true;
  # hardware.logitech.wireless.enableGraphical = true; # Solaar.

  # environment.systemPackages = with pkgs; [
  #   headsetcontrol2
  #   solaar
  # ];

  # services.udev.packages = with pkgs; [
  #   headsetcontrol2
  #   logitech-udev-rules
  #   solaar
  # ];

  services.dbus.enable = true;
  services.dbus.packages = [pkgs.gcr];
  environment.pathsToLink = [
    "/share/fish"
    "/share/zsh"
    "/share/bash"
  ];
}
