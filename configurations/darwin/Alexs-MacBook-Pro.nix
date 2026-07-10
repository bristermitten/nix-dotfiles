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
    inputs.agenix.darwinModules.default
  ];


  nixpkgs.hostPlatform = "aarch64-darwin";
  networking.hostName = "Alexs-MacBook-Pro";

  # For home-manager to work.
  # https://github.com/nix-community/home-manager/issues/4026#issuecomment-1565487545
  users.users."alex".home = "/Users/alex";

  # Enable home-manager for "alex" user
  home-manager.backupFileExtension = "backup";
  home-manager.users."alex" = {
    imports = [ (self + /configurations/home/alex.nix) ];
  };

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
  system.primaryUser = "alex";
  nixpkgs.config.allowUnfree = true;

  nixpkgs.config.permittedInsecurePackages = [ # hopefully logseq will update soon
    "electron-39.8.10"
  ];

  # Personal-only casks (gaming/media/cosmetic), on top of the shared
  # list in modules/darwin/brew.nix.
  homebrew.casks = [
    "brightintosh"
    "music-presence"
    "plex"
    "prismlauncher"
    "shadow"
    "steam"
    "whatsapp"
  ];
}
