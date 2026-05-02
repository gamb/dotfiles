{
  description = "Home Manager configuration of adamgamble";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    emacs-overlay.url = "github:nix-community/emacs-overlay";
  };

  outputs =
    { nixpkgs, home-manager, emacs-overlay, ... }:
    let
      system = "aarch64-darwin";
      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          emacs-overlay.overlays.default
          # Workaround direnv issue, thanks to https://github.com/billimek/dotfiles/commit/eed207e535ec8d923ab7ccdec5d10972fe77d800
          # via https://github.com/NixOS/nixpkgs/issues/507531
          (_final: prev: {
            fish = prev.fish.overrideAttrs (_old: {
              # Bust the cache key so fish is always built locally rather than
              # substituted from the binary cache where the signature may be stale.
              NIX_FORCE_LOCAL_REBUILD = "darwin-codesign-fix";
            });
          })
        ];
      };
    in
    {
      homeConfigurations."macbook" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [ ./home-manager/macbook.nix ];

        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
      };
    };
}
