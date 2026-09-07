{ lib, pkgs, mattpocock-skills, ... }:

let
  alerter = pkgs.callPackage ../packages/alerter.nix { };

  # Registered in ~/.claude/settings.json as a PermissionRequest hook. That file
  # stays out of home-manager because Claude Code writes to it itself.
  permission-notify = pkgs.writeShellApplication {
    name = "permission-notify";
    runtimeInputs = [
      alerter
      pkgs.jq
    ];
    text = builtins.readFile ./claude-permission-notify.sh;
  };
in
{
  # The instructions are inlined rather than kept in a repo-root CLAUDE.md, so
  # Claude Code does not also read them as project instructions for this repo.
  home.file = {
    "CLAUDE.md".text = ''
      Write all responses in ASD-STE100 Simplified Technical English.
    '';
    ".claude/hooks/permission-notify".source = "${permission-notify}/bin/permission-notify";
  }
  // lib.listToAttrs (
    map (p: {
      name = ".claude/skills/${baseNameOf p}";
      value.source = "${mattpocock-skills}/${lib.removePrefix "./" p}";
    }) (builtins.fromJSON (builtins.readFile "${mattpocock-skills}/.claude-plugin/plugin.json")).skills
  );
}
