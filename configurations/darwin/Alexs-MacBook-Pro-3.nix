# See /modules/darwin/* for actual settings
# This file is just *top-level* configuration.
{ flake, ... }:

let
  inherit (flake) inputs;
  inherit (inputs) self;
in
{
  imports = [
    self.darwinModules.default
    inputs.determinate.darwinModules.default
  ];


  nixpkgs.hostPlatform = "aarch64-darwin";
  networking.hostName = "Alexs-MacBook-Pro-3";

  # For home-manager to work.
  # https://github.com/nix-community/home-manager/issues/4026#issuecomment-1565487545
  users.users."alex".home = "/Users/alex";

  # Enable home-manager for "alex" user
  home-manager.users."alex" = {
    imports = [ (self + /configurations/home/alex.nix) ];
  };

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
