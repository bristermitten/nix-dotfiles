{ flake, ... }:

let
  inherit (flake) inputs;
  inherit (inputs) self;
in
{
  imports = [
    #self.nixosModules.default
    #self.nixosModules.gui
    ./configuration.nix
  ];

  # Enable home-manager for "runner" user
  home-manager.users."alex" = {
    imports = [ (self + /configurations/home/alex.nix) ];
  };
}
