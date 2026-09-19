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
        # Default poll_time is 5s, and since this watcher's payload (full
        # psutil dump) changes almost every poll, heartbeats essentially
        # never dedupe server-side — at 5s that wrote 1.1M events / ~7.9GB
        # into the shared sqlite db. 30s cuts that ~6x while keeping useful
        # resolution.
        #
        # aw-watcher-utilization loads this via aw_core's *deprecated*
        # load_config(), which reads "<name>.toml" but writes back to
        # "<name>.ini" — so the section header below must match what
        # ConfigParser expects, not real nested TOML semantics.
        settings."aw-watcher-utilization".poll_time = 30;
      };
      aw-watcher-enhanced = {
        package = pkgs.callPackage (self + /packages/aw-watcher-enhanced.nix) { };
      };
    };
  };
}
