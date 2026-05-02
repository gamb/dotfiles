{ configs, pkgs, ... }:

{
  programs.emacs = {
    enable = true;
    package = (pkgs.emacsPackagesFor pkgs.emacs).emacsWithPackages (
      epkgs: with epkgs; [
        (epkgs.trivialBuild {
          pname = "eglot-hierarchy";
          version = "unstable";
          src = pkgs.fetchFromGitHub {
            owner = "dolmens";
            repo = "eglot-hierarchy";
            rev = "main";
            sha256 = "sha256-Eh+gglFAv7WPVTi5UP6otlulxxkRWzEPkbPw7EJZ7l4=";
          };
          packageRequires = with epkgs; [ eglot ];
        })
        cape
        clojure-mode
        consult
        corfu
        embark-consult
        envrc
        exec-path-from-shell
        fullframe
        j-mode
        magit
        marginalia
        move-dup
        ns-auto-titlebar
        orderless
        paredit
        tempel
        tuareg
        vertico
        whole-line-or-region
        (treesit-grammars.with-grammars (
          treesit-pkgs: with treesit-pkgs; [
            tree-sitter-typescript
            tree-sitter-ocaml
            tree-sitter-ruby
            tree-sitter-nix
            tree-sitter-tsx
            tree-sitter-json
          ]
        ))
      ]
    );
    extraConfig = builtins.readFile ../config.el;
  };

  services.emacs = {
    enable = true;
    startWithUserSession = true;

    client = {
      enable = true;
    };
  };

}
