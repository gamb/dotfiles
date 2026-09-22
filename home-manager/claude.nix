{ lib, pkgs, ... }:

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

  skillDirs = lib.filterAttrs (_: type: type == "directory") (builtins.readDir ../skills);
  agentFiles = lib.filterAttrs (name: type: type == "regular" && lib.hasSuffix ".md" name) (
    builtins.readDir ../agents
  );
in
{
  home.file = {
    "CLAUDE.md".text = ''
      Write all responses in ASD-STE100 Simplified Technical English.
    '';
    ".claude/hooks/permission-notify".source = "${permission-notify}/bin/permission-notify";
  }
  // lib.mapAttrs' (name: _: {
    name = ".claude/skills/${name}";
    value.source = ../skills + "/${name}";
  }) skillDirs
  // lib.mapAttrs' (name: _: {
    name = ".claude/agents/${name}";
    value.source = ../agents + "/${name}";
  }) agentFiles;
}
