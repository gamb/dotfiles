{
  pkgs ? import <nixpkgs> { },
}:

let
  version = "0.32.1";
  platform =
    {
      aarch64-darwin = {
        suffix = "darwin_arm64";
        hash = "sha256-b9Lzn67rL23ExaB8IYHFDJ8F7htA/crFRnOyuZcRs8I=";
      };
      x86_64-darwin = {
        suffix = "darwin_amd64";
        hash = "sha256-9didApopdeluYY2aIt8AxEHB2hOJL0JynNy0rk29dN4=";
      };
      aarch64-linux = {
        suffix = "linux_arm64";
        hash = "sha256-jAWXIhQgdtPdoxZlWzybhvBWvYcK8xq/33oigbjmrx4=";
      };
      x86_64-linux = {
        suffix = "linux_amd64";
        hash = "sha256-//zlauJDmpIBYa73E5hEWhIVED+TErgKXaLwsgSqs7E=";
      };
    }
    .${pkgs.stdenv.hostPlatform.system};
in
pkgs.stdenv.mkDerivation {
  pname = "agentsview";
  inherit version;

  # Upstream is Go + an embedded Svelte frontend; packaging the prebuilt
  # release binary avoids a two-toolchain source build.
  src = pkgs.fetchurl {
    url = "https://github.com/kenn-io/agentsview/releases/download/v${version}/agentsview_${version}_${platform.suffix}.tar.gz";
    hash = platform.hash;
  };

  # The tarball contains only the binary, no top-level directory.
  sourceRoot = ".";
  dontBuild = true;

  installPhase = ''
    install -Dm755 agentsview $out/bin/agentsview
  '';

  meta = with pkgs.lib; {
    description = "Local-first session intelligence and analytics for coding agents";
    homepage = "https://www.agentsview.io";
    license = licenses.mit;
    mainProgram = "agentsview";
    platforms = [
      "aarch64-darwin"
      "x86_64-darwin"
      "aarch64-linux"
      "x86_64-linux"
    ];
  };
}
