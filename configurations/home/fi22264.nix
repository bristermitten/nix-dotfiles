# University laptop home-manager config
{ flake, pkgs, lib, ... }:
let
  inherit (flake) inputs;
  inherit (inputs) self;
in
{
  imports = [
    self.homeModules.default
    inputs.agenix.homeManagerModules.default
  ];
  home.username = "fi22264";
  home.homeDirectory = lib.mkDefault "/${if pkgs.stdenv.isDarwin then "Users" else "home"}/fi22264";
  home.stateVersion = "24.05";
  home.sessionPath = [ "$HOME/.local/bin" ];

  # University device: ActivityWatch data stays local (no push to the homelab).
  # Overrides the shared remoteServer in modules/home/lastfm-tracking.nix.
  services.activitywatchDarwin.remoteServer = lib.mkForce null;

  programs.git.signing.key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKwuud+4Cwa4hLVsI8MZWSMEj/d9JRo1qBwBubjeJWPi";
}
