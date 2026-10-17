{
  programs.git = {
    enable = true;
    ignores = [ ".direnv/" ];
    settings = {
      user = {
        name = "Adam Gamble";
        email = "adam.gamble@hey.com";
      };
      init.defaultBranch = "main";
    };
  };
}
