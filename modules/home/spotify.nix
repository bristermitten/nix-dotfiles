{ pkgs, flake, ... }:
{
  imports = [ 
 flake.inputs.spicetify-nix.homeManagerModules.default ];

   programs.spicetify =
    let
      spicePkgs = flake.inputs.spicetify-nix.legacyPackages.${pkgs.system};
    in
    {
      enable = true;
      #spicetifyPackage = pkgs.spicetify-cli;
      #spotifyPackage = pkgs.spotify;
      enabledExtensions = with spicePkgs.extensions; [ shuffle powerBar skipStats lastfm betterGenres songStats ];

      theme = spicePkgs.themes.spotifyNoPremium;

      alwaysEnableDevTools = false;

    };


}
