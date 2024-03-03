{ pkgs, inputs, outputs, lib, config, ... }: {
  imports =
    [
      inputs.home-manager.nixosModules.home-manager
      
      ./fonts.nix
      ./hardware.nix
      ./locale.nix
      ./nix.nix
      ./opengl.nix
      ./openssh.nix
      ./pam.nix
      ./sops.nix
      ./rdp.nix

      ./optional/auto-upgrade.nix
      ./optional/docker.nix
      ./optional/hardening.nix
      ./optional/greetd.nix
      ./optional/virtualisation.nix
    ] ++ (builtins.attrValues outputs.nixosModules);


  home-manager.extraSpecialArgs = {inherit inputs outputs;};

  services = {
    pcscd.enable = true;
    udev.packages = with pkgs; [yubikey-personalization];
    gvfs.enable = true;
    udisks2.enable = true;
    fwupd.enable = true;
    dbus.packages = [pkgs.gcr];
  };

  nixpkgs = {
    overlays = builtins.attrValues outputs.overlays;
    config = {
      allowUnfree = true;
    };
  };

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      #jack.enable = true;

      # use the example session manager (no others are packaged yet so this is enabled by default,
      # no need to redefine it in your config for now)
      #media-session.enable = true;
  };
}
