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

  # Separate identity from the personal laptop, same GitHub account.
  programs.git.settings.user.email = "alexander.wood@bristol.ac.uk";
  programs.git.signing.key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKwuud+4Cwa4hLVsI8MZWSMEj/d9JRo1qBwBubjeJWPi";
}
