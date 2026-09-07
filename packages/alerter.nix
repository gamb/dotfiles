{
  lib,
  stdenvNoCC,
  fetchzip,
}:

# Notifications with answer buttons. terminal-notifier cannot do this: its only
# click option is -execute, which runs a command and tells the caller nothing.
# alerter blocks until the notification is answered and prints the answer, so a
# Claude Code hook can turn that answer into a permission decision.
#
# Upstream ships a signed arm64 binary (Developer ID: Valere JEANTET,
# NQLLJK2GK3). It is not built from source here because that needs Xcode.
stdenvNoCC.mkDerivation rec {
  pname = "alerter";
  version = "26.5";

  src = fetchzip {
    url = "https://github.com/vjeantet/alerter/releases/download/v${version}/alerter-${version}.zip";
    hash = "sha256-JSqn8a1t3cWY/ZDynbqq7T+3Hm8XNOMGM9uhBv7RG2E=";
    stripRoot = false;
  };

  dontFixup = true; # Keep the signature intact: macOS drops notifications from a modified binary.

  installPhase = ''
    runHook preInstall
    install -Dm755 alerter $out/bin/alerter
    runHook postInstall
  '';

  meta = {
    description = "Send macOS notifications with action buttons and read the answer";
    homepage = "https://github.com/vjeantet/alerter";
    license = lib.licenses.mit;
    platforms = [ "aarch64-darwin" ];
    mainProgram = "alerter";
  };
}
