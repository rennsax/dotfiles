# Add org-protocol URL handler for OS X. Must be built in non-sandbox mode.
{
  stdenvNoCC,
  emacs,
  lib,
  ...
}:
let
  appName = "OrgProtocolClient.app";
  plistName = "${appName}/Contents/Info.plist";
  plistBuddyCmd = cmd: "/usr/libexec/PlistBuddy -c ${lib.escapeShellArg cmd} ${plistName}";
in
stdenvNoCC.mkDerivation rec {
  pname = "org-protocol-client";
  version = "1.0.0";

  dontUnpack = true;

  buildPhase = ''
    runHook preBuild
    /usr/bin/osacompile -o ${appName} << EOF
    on open location this_URL
       do shell script "${emacs}/bin/emacsclient \"" & this_URL & "\""
       tell application "Emacs" to activate
    end open location
    EOF
    ${lib.concatStringsSep "\n" (
      map plistBuddyCmd [
        "Add :CFBundleURLTypes array"
        "Add :CFBundleURLTypes:0 dict"
        "Add :CFBundleURLTypes:0:CFBundleURLName string 'org-protocol handler'"
        "Add :CFBundleURLTypes:0:CFBundleURLSchemes array"
        "Add :CFBundleURLTypes:0:CFBundleURLSchemes:0 string 'org-protocol'"
      ]
    )}
    runHook postBuild
  '';
  installPhase = ''
    runHook preInstall
    mkdir -p $out/Applications
    cp -R ${appName} $out/Applications/
    runHook postInstall
  '';

  meta = with lib; {
    platforms = [ "aarch64-darwin" ];
  };
}
