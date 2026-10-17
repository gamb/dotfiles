{ lib, pkgs, ... }:

let
  noShortcuts = lib.hm.gvariant.mkEmptyArray lib.hm.gvariant.type.string;
in
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

  # Release Super and its combinations used as Meta shortcuts in Emacs.
  dconf.settings = {
    "org/gnome/mutter".overlay-key = "";
    "org/gnome/shell/keybindings" = {
      toggle-application-view = noShortcuts;
      toggle-message-tray = noShortcuts;
      toggle-quick-settings = noShortcuts;
    };
    "desktop/ibus/panel/emoji".hotkey = noShortcuts;
    "org/gnome/settings-daemon/plugins/media-keys" = {
      rotate-video-lock-static = [ "XF86RotationLockToggle" ];
    };
    "org/gnome/desktop/wm/keybindings" = {
      switch-group = [ "<Alt>Above_Tab" ];
      switch-group-backward = [ "<Shift><Alt>Above_Tab" ];
    };
  };

  programs.fish.enable = true;
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
