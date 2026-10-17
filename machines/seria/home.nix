{
  imports = [
    ../../home-manager/emacs.nix
    ../../home-manager/fonts.nix
    ../../home-manager/git.nix
  ];

  home.username = "gamble";
  home.homeDirectory = "/home/gamble";
  home.stateVersion = "26.05";

  home.packages = [
    pkgs.llm-agents.codex
    pkgs.llm-agents.codex-acp
  ];
  programs.fish.enable = true;
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
