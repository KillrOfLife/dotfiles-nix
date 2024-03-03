{ config, pkgs, lib, ... }: {

  environment.systemPackages = [
    pkgs.wayvnc
  ];


}