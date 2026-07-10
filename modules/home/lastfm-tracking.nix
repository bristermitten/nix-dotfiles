# Personal ActivityWatch watchers + the Last.fm secret they need.
# Shared across every user via modules/home/default.nix's auto-import.
{ flake, config, pkgs, ... }:
let
  inherit (flake) inputs;
  inherit (inputs) self;
in
{
  age.identityPaths = [ "${config.home.homeDirectory}/.ssh/id_ed25519" ];

  age.secrets.lastfm-config = {
    file = self + /secrets/lastfm-config.yaml.age;
  };

  services.activitywatchDarwin = {
    enable = true;
    watchers = {
      aw-watcher-lastfm = {
        package = pkgs.callPackage (self + /packages/aw-watcher-lastfm.nix) { };
        settingsFilename = "config.yaml";
        configFile = config.age.secrets.lastfm-config.path;
      };
      aw-watcher-utilization = {
        package = pkgs.callPackage (self + /packages/aw-watcher-utilization.nix) { };
      };
      aw-watcher-enhanced = {
        package = pkgs.callPackage (self + /packages/aw-watcher-enhanced.nix) { };
      };
    };
  };
}
