{ pkgs, ... }:

{
  # Add shared modules and plugin configuration from ../../home-manager here.
  imports = [ ];

  home.username = "gamble";
  home.homeDirectory = "/home/gamble";
  home.stateVersion = "26.05";

  home.packages = [ pkgs.git ];
}
