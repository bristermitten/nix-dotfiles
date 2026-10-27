# Top-level flake glue to get our configuration working
{ inputs, lib, ... }:

let
  # autoWire exposes modules as bare path strings, which `nix flake check`
  # rejects (isFunctionOrAttrs). Re-expose each as an attrset that imports it.
  wireModules = dir:
    lib.mapAttrs' (fn: type: lib.nameValuePair (lib.removeSuffix ".nix" fn) { imports = [ (dir + "/${fn}") ]; })
      (lib.filterAttrs
        (fn: type:
          (type == "regular" && lib.hasSuffix ".nix" fn)
          || (type == "directory" && builtins.pathExists (dir + "/${fn}/default.nix")))
        (builtins.readDir dir));
in
{
  imports = [
    inputs.nixos-unified.flakeModules.default
    inputs.nixos-unified.flakeModules.autoWire
    inputs.treefmt-nix.flakeModule
  ];

  flake = {
    darwinModules = lib.mkForce (wireModules (inputs.self + "/modules/darwin"));
    homeModules = lib.mkForce (wireModules (inputs.self + "/modules/home"));
  };

  perSystem = { self', pkgs, ... }: {
    # Enables 'nix run' to activate.
    packages.default = self'.packages.activate;



    treefmt.config = {
      projectRoot = inputs.self;
      programs.nixpkgs-fmt.enable = true;
    };
  };
}
