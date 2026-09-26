{ flake, ... }:
{
  imports = [
    flake.inputs.nixvim.homeModules.nixvim
  ];

  programs.nixvim = {
    imports = [ ./nixvim.nix ];
    enable = true;
  };
}
