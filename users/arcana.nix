{config, pkgs, ... } : 
let 
    ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in {
    home-manager.users.arcana = import ../hosts/${config.networking.hostName}/home.nix;

    sops.secrets.arcana = {
        sopsFile = ./secrets.yaml;
        neededForUsers = true;
    };
    
    users.users.arcana = {
        isNormalUser = true;
        description = "arcana";
        shell = pkgs.fish;
        createHome = true;
        home = "/home/arcana";
        extraGroups = [
            "wheel"
        ] ++ ifTheyExist [
            "video"
            "audio"
            "networkmanager"
            "libvirtd"
            "kvm"
            "docker"
            "podman"
            "git"
            "network"
            "wireshark"
            "i2c"
            "tss"
            "plugdev"
        ];

        packages = [
            pkgs.home-manager
        ];
        
        openssh.authorizedKeys.keys = [ 
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG5BRKIFhkbNDgELm/iTP8QHcanlsVNo+RlE3pRDRwDA arcana@Revision-PC-AMD"
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDpTwXq8dZpn5dI/eNEXyqDREautKqjBXXGCs/yrLLp2bE9y7cH64HNUNUb+Eu9kdYDXui3DZsK1o+Rjg5sr0+qBm/tu2l9fS0/+3uQu+Dx6+pms4pGKUQ8CVlAxeDO0U/UO3ZirN2buzqWtKr6n8YvhaVxm3i75M0iDFW40vWYv+uU/bOOlOq9E6G3SM5dGqVT4Haz4CPXM5qSfTh6cf1gAoE72zNbU/Gtr08+If4zquQHHvvmuGB4U0671Ktirmfu5v9if+cqzDka6ayZinzci0ekY7LIg2B7x1RHP4d2eNQrxH3x65IvdQShMa3fZtIr8UER7xkHlLMljWlL4rwCzFVwGWJPoDkVYK3P009yDzIz1t1D5+9WvX9/iYqmgfmHaZAPtMbHcO/QonR9lXAMyLJ6FbyT9+TvyANO00PhYG9U9f9RzU0UlNdgiBED9/uxKl9Yv2XpyERYLocwwVdRtJdL889NT9fcbmRtsVzYoW0IMVloEJ5Vl29T7GXM+Cs= hpcds\50052560@AutoPCfm37QDt2r"

        ];
        #hashedPasswordFile = config.sops.secrets.haseeb-password.path;
    };

    programs.fish.enable = true;

}