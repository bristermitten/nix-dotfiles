# Top-level flake glue to get our configuration working
{ inputs, ... }:

{
  imports = [
    inputs.nixos-unified.flakeModules.default
    inputs.nixos-unified.flakeModules.autoWire
    inputs.treefmt-nix.flakeModule
  ];
  perSystem = { self', pkgs, ... }: {
    # Enables 'nix run' to activate.
    packages.default = self'.packages.activate;



    treefmt.config = {
      projectRoot = inputs.self;
      programs.nixpkgs-fmt.enable = true;
    };
  };
}
