{ flake, ... }:
{
  imports = [
    flake.inputs.nix-index-database.homeModules.nix-index
  ];

  # command-not-found handler to suggest nix way of installing stuff.
  # FIXME: Update to show new Nix CLI commands (see nix-community/nix-index#191)
  programs.nix-index = {
    enable = true;
    enableZshIntegration = true;
  };

}
