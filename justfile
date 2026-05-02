init:
  nix run home-manager/release-25.05 -- init --switch

build:
  home-manager build --flake .#macbook

switch:
  home-manager switch --flake .#macbook -b backup

update-lock:
  nix flake update

expire:
  home-manager expire-generations "-30 days"
