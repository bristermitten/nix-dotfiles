{ pkgs, ... }:
{


  home.packages =
    if pkgs.stdenv.isDarwin then [
      (pkgs.discord.override {
        withOpenASAR = true;
        # withVencord = true; # can do this here too
      })
    ] else [ ];
}
