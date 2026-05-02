init:
  nix run home-manager/release-25.05 -- init --switch

build:
  home-manager build --flake .#adamgamble

switch:
  home-manager switch --flake .#adamgamble -b backup
