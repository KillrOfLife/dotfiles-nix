{pkgs, ...}: {
  programs.vscode = {
    enable = true;
    # extensions = with pkgs.vscode-extensions; [
    #     dracula-theme.theme-dracula
        
    #     ms-azuretools.vscode-docker
    #     bbenoist.nix
    #     ms-vscode-remote.remote-ssh
    #     # ms-vscode.remote-explorer

    # ];
  };
}
