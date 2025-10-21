{ pkgs, lib, ... }:

let
  jdkVersions = [ 8 11 17 21 25 ];
  #  iterate over jdk versions and symlink them to the JavaVirtualMachines directory
  #  source: https://samasaur1.github.io/blog/jdks-on-nix-darwin
  makeZuluLinks = { pkgs, lib }: versions:
    lib.concatStringsSep "\n" (
      lib.map
        (version:
          let
            versionStr = toString version;
            jdkPackage = pkgs."jdk${versionStr}";
            jdkDir = "zulu-${versionStr}.jdk";
          in
          ''
            ln -sf "${jdkPackage}/Library/Java/JavaVirtualMachines/${jdkDir}" "/Library/Java/JavaVirtualMachines/"
          ''
        )
        versions
    );
in
{

  system.activationScripts.extraActivation.text =
    makeZuluLinks { inherit pkgs lib; } jdkVersions;
}
