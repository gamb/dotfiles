{
  imports = [
    ../../home-manager/emacs.nix
    ../../home-manager/fonts.nix
    ../../home-manager/git.nix
  ];

  home.username = "gamble";
  home.homeDirectory = "/home/gamble";
  home.stateVersion = "26.05";

  programs.fish.enable = true;
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
