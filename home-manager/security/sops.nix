{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];

  sops = {
    gnupg = {
      # home = "~/.gnupg";
      sshKeyPaths = [ "~/.ssh/id_ed25519" ];
    };
    defaultSymlinkPath = "/run/user/1000/secrets";
    defaultSecretsMountPoint = "/run/user/1000/secrets.d";
  };

  home.packages = with pkgs; [
    sops
  ];
}
