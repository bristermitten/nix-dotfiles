{ flake, config, pkgs, lib, ... }:
let
  inherit (flake) inputs;
  inherit (inputs) self;
in
{
  imports = [
    self.homeModules.default
    inputs.agenix.homeManagerModules.default
  ];
  home.username = "alex";
  home.homeDirectory = lib.mkDefault "/${if pkgs.stdenv.isDarwin then "Users" else "home"}/alex";
  home.stateVersion = "24.05";
  home.sessionPath = [ "$HOME/.local/bin" ];

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
    };
  };
}
