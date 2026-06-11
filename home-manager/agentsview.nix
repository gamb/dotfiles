{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.agentsview;
in
{
  options.programs.agentsview = {
    enable = lib.mkEnableOption "AgentsView, session analytics for coding agents";

    package = lib.mkOption {
      type = lib.types.package;
      default = import ../packages/agentsview.nix { inherit pkgs; };
      description = "The agentsview package to install.";
    };

    service = {
      enable = lib.mkEnableOption "running the AgentsView server as a launchd agent";

      port = lib.mkOption {
        type = lib.types.port;
        default = 8080;
        description = "Port the AgentsView web UI listens on (bound to 127.0.0.1).";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];

    launchd.agents.agentsview = lib.mkIf cfg.service.enable {
      enable = true;
      config = {
        ProgramArguments = [
          (lib.getExe cfg.package)
          "serve"
          "--no-browser"
          "--port"
          (toString cfg.service.port)
        ];
        RunAtLoad = true;
        KeepAlive = true;
        ProcessType = "Background";
        StandardOutPath = "${config.home.homeDirectory}/Library/Logs/agentsview.log";
        StandardErrorPath = "${config.home.homeDirectory}/Library/Logs/agentsview.log";
      };
    };
  };
}
