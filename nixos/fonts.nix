{pkgs, ...}: {
  nixpkgs.config.joypixels.acceptLicense = true;
  fonts = {
    enableDefaultPackages = false;
    fontDir.enable = true;
    packages = with pkgs; [
      (nerdfonts.override {fonts = ["FiraCode" "Meslo" "SourceCodePro" "UbuntuMono"];})
      fira
      fira-go
      font-awesome
      joypixels
      liberation_ttf
      noto-fonts-emoji
      source-serif
      ubuntu_font_family
      work-sans
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      liberation_ttf
      fira-code
      fira-code-symbols
      fira-code-nerdfont
      roboto
      ubuntu_font_family
      oxygenfonts
      cantarell-fonts
      open-sans
      mplus-outline-fonts.githubRelease
      dina-font
      proggyfonts
      source-han-sans
      source-han-sans-japanese
      source-han-serif-japanese
    ];

    fontconfig = {
      antialias = true;
      defaultFonts = {
        serif = ["Source Serif"];
        sansSerif = ["Work Sans" "Fira Sans" "FiraGO"];
        monospace = ["FiraCode Nerd Font Mono" "SauceCodePro Nerd Font Mono"];
        emoji = ["Joypixels" "Noto Color Emoji"];
      };
      enable = true;
      hinting = {
        autohint = false;
        enable = true;
        style = "slight";
      };
      subpixel = {
        rgba = "rgb";
        lcdfilter = "light";
      };
    };
  };

  console = {
    earlySetup = true;
    font = "ter-u28n";
    packages = with pkgs ;[ 
      fira-code
      terminus_font 
    ];
  };
}
