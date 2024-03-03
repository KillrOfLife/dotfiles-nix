{inputs, ...}: {
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  sops = {
    # gnupg = {
    #   home = "~/.gnupg";
    #   sshKeyPaths = [];
    # };
    age.sshKeyPaths = ["/home/arcana/.ssh/id_ed25519"];
  };
}
