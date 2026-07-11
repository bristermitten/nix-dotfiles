# See /modules/darwin/* for actual settings
# University laptop (fi22264)
{ flake, ... }:

let
  inherit (flake) inputs;
  inherit (inputs) self;
in
{
  imports = [
    self.darwinModules.default
    inputs.determinate.darwinModules.default
    inputs.agenix.darwinModules.default
  ];


  nixpkgs.hostPlatform = "aarch64-darwin";
  networking.hostName = "JT907G791C";

  # For home-manager to work.
  # https://github.com/nix-community/home-manager/issues/4026#issuecomment-1565487545
  users.users."fi22264".home = "/Users/fi22264";

  home-manager.backupFileExtension = "backup";
  # Enable home-manager for "fi22264" user
  home-manager.users."fi22264" = {
    imports = [ (self + /configurations/home/fi22264.nix) ];
  };

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
  system.primaryUser = "fi22264";
  nixpkgs.config.allowUnfree = true;

  nixpkgs.config.permittedInsecurePackages = [ # hopefully logseq will update soon
    "electron-39.8.10"
  ];
}
