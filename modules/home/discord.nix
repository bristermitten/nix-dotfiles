{ pkgs, ... }:
{


  home.packages = [
    (pkgs.discord.override {
      withOpenASAR = false;
      # withVencord = true; # can do this here too
    })
  ];
}
