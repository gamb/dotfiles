init:
  nix run home-manager/release-25.05 -- init --switch

build:
  home-manager build

switch:
  home-manager switch
