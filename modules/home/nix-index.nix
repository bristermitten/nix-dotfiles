{ flake, ... }:
{
  imports = [
    flake.inputs.nix-index-database.homeModules.nix-index
  ];

  # command-not-found handler to suggest nix packages for missing commands
  programs.nix-index = {
    enable = true;
    enableZshIntegration = true;
  };

  # comma: run any program with `, program` (auto-fetches from nixpkgs)
  programs.nix-index-database.comma.enable = true;

}
